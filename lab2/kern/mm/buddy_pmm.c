#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_pmm.h>
#include <stdio.h>

// 定义伙伴系统的全局结构
free_buddy_t buddy_s;

#define buddy_array (buddy_s.free_array)
#define max_order (buddy_s.max_order)
#define nr_free (buddy_s.nr_free)

// 检查是否为2的幂
static int IS_POWER_OF_2(size_t n) {
    return (n & (n - 1)) == 0;
}

// 获取大小为2的幂的阶数（例如：8 -> 3，16 -> 4）
static unsigned int getOrderOf2(size_t n) {
    unsigned int order = 0;
    while (n >> 1) {
        n >>= 1;
        order++;
    }
    return order;
}

// 将给定大小向下取整为2的幂（例如：9 -> 8，15 -> 8）
static size_t ROUNDDOWN2(size_t n) {
    if (IS_POWER_OF_2(n)) {
        return n;
    }
    size_t res = 1;
    while (n >>= 1) {
        res <<= 1;
    }
    return res;
}

// 将给定大小向上取整为2的幂（例如：9 -> 16，15 -> 16）
static size_t ROUNDUP2(size_t n) {
    if (IS_POWER_OF_2(n)) {
        return n;
    }
    size_t res = 1;
    while (n >>= 1) {
        res <<= 1;
    }
    return res << 1;
}

// 打印伙伴系统的当前状态，用于调试
static void show_buddy_array(void) {
    cprintf("[TEST]Buddy System: Print buddy array:\n");
    cprintf("---------------------------\n");
    for (int i = 0; i < max_order + 1; i++) {
        cprintf("No. %d: ", i);
        list_entry_t *le = &(buddy_array[i]);
        while ((le = list_next(le)) != &(buddy_array[i])) {
            struct Page *p = le2page(le, page_link);
            cprintf("%d ", page2ppn(p));
            cprintf("%d ", 1 << (p->property));
        }
        cprintf("\n");
    }
    cprintf("---------------------------\n");
}

// 初始化伙伴系统的各个链表头节点
static void buddy_init(void) {
    for (int i = 0; i <= MAX_BUDDY_ORDER; i++) {
        list_init(buddy_array + i);
    }
    max_order = 0;
    nr_free = 0;
}

// 获取指定页的伙伴页
static struct Page *buddy_get_buddy(struct Page *page) {
    size_t order = page->property;
    size_t buddy_ppn = first_ppn + ((1 << order) ^ (page2ppn(page) - first_ppn));
    // 根据页偏移和当前阶数，通过异或操作确定伙伴页的位置
    return (buddy_ppn > page2ppn(page)) ? (page + (buddy_ppn - page2ppn(page))) : (page - (page2ppn(page) - buddy_ppn));
}

// 初始化伙伴系统内存映射，将物理页初始化为伙伴系统可管理的块
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    size_t pnum = ROUNDDOWN2(n);  // 向下取整为2的幂
    size_t order = getOrderOf2(pnum);
    struct Page *p = base;

    // 初始化可管理的物理页
    for (; p != base + pnum; p++) {
        assert(PageReserved(p));
        p->flags = 0;
        p->property = 0;
        set_page_ref(p, 0);
    }

    // 处理多余的非2的幂次的页
    size_t remaining = n - pnum;
    if (remaining > 0) {
        for (; p != base + n; p++) {
            p->flags = 0;
            p->property = 0;
            set_page_ref(p, 0);
        }
        // 将多余的页作为较小的块加入伙伴系统
        list_add(&(buddy_array[getOrderOf2(remaining)]), &(base->page_link));
    }

    max_order = order;
    nr_free = pnum + remaining;
    list_add(&(buddy_array[max_order]), &(base->page_link));
    base->property = max_order;
}

// 分裂内存块，将较大的块分解为两个较小的块
static void buddy_split(size_t n) {
    assert(n > 0 && n <= max_order);
    assert(!list_empty(&(buddy_array[n])));
    cprintf("[TEST]Buddy System: SPLIT!\n");
    struct Page *page_a;
    struct Page *page_b;

    page_a = le2page(list_next(&(buddy_array[n])), page_link);
    page_b = page_a + (1 << (n - 1));

    page_a->property = n - 1;
    page_b->property = n - 1;

    cprintf("[TEST]Buddy System: a is %d ", page_a);
    cprintf("[TEST]Buddy System: b is %d ", page_b);

    list_del(list_next(&(buddy_array[n])));
    list_add(&(buddy_array[n - 1]), &(page_a->page_link));
    list_add(&(page_a->page_link), &(page_b->page_link));
}

// 分配所需的页数，返回首个分配的页
static struct Page *buddy_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    size_t pnum = ROUNDUP2(n);
    size_t order = getOrderOf2(pnum);
    cprintf("[TEST]Buddy System: Allocating %d-->%d = 2^%d pages ...\n", n, pnum, order);
    show_buddy_array();

    while (1) {
        if (!list_empty(&(buddy_array[order]))) {
            page = le2page(list_next(&(buddy_array[order])), page_link);
            list_del(list_next(&(buddy_array[order])));
            SetPageProperty(page);
            cprintf("[TEST]Buddy System: Buddy array after ALLOC NO.%d page:\n", page2ppn(page));
            show_buddy_array();
            break;
        } else {
            for (int i = order + 1; i <= max_order; i++) {
                if (!list_empty(&(buddy_array[i]))) {
                    buddy_split(i);
                    cprintf("[!]BS: Buddy array after SPLIT:\n");
                    show_buddy_array();
                    break;
                }
            }
        }
    }
    nr_free -= pnum;
    cprintf("[!]BS: nr_free: %d\n", nr_free);
    return page;
}

// 释放所指定的页数并合并相邻的伙伴页
static void buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    size_t pnum = 1 << (base->property);
    assert(ROUNDUP2(n) == pnum);
    cprintf("[TEST]Buddy System: Free NO.%d page about %d pages block: \n", page2ppn(base), pnum);

    struct Page *left_block = base;
    struct Page *buddy = NULL;
    struct Page *tmp = NULL;

    show_buddy_array();
    list_add(&(buddy_array[left_block->property]), &(left_block->page_link));
    cprintf("[TEST]Buddy System: add to list\n");
    show_buddy_array();

    buddy = buddy_get_buddy(left_block);

    while (!PageProperty(buddy) && left_block->property < max_order) {
        cprintf("[TEST]Buddy System: Buddy free, MERGING!\n");
        if (left_block > buddy) {
            left_block->property = 0;
            ClearPageProperty(left_block);
            tmp = left_block;
            left_block = buddy;
            buddy = tmp;
        }
        list_del(&(left_block->page_link));
        list_del(&(buddy->page_link));
        left_block->property += 1;
        list_add(&(buddy_array[left_block->property]), &(left_block->page_link));
        show_buddy_array();
        buddy = buddy_get_buddy(left_block);
    }
    cprintf("[TEST]Buddy System: Buddy array finished FREE:\n");
    ClearPageProperty(left_block);
    nr_free += pnum;
    show_buddy_array();
    cprintf("[TEST]Buddy System: nr_free is %d\n", nr_free);
}

// 获取剩余的空闲页数
static size_t buddy_nr_free_pages(void) {
    return nr_free;
}

// 进行基本的内存分配和释放测试
static void basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    cprintf("!!! 第一次分配 !!!\n");
    assert((p0 = alloc_page()) != NULL);
    cprintf("!!! 第二次分配 !!!\n");
    assert((p1 = alloc_page()) != NULL);
    cprintf("!!! 第三次分配 !!!\n");
    assert((p2 = alloc_page()) != NULL);

    cprintf("!!! 第一次释放 !!!\n");
    free_page(p0);
    cprintf("!!! 第二次释放 !!!\n");
    free_page(p1);
    cprintf("!!! 第三次释放 !!!\n");
    free_page(p2);
    show_buddy_array();

    cprintf("!!! 第四次分配-4 !!!\n");
    assert((p0 = alloc_pages(4)) != NULL);
    cprintf("!!! 第五次分配-2 !!!\n");
    assert((p1 = alloc_pages(2)) != NULL);
    cprintf("!!! 第六次分配-1 !!!\n");
    assert((p2 = alloc_pages(1)) != NULL);
    cprintf("!!! 第四次释放 !!!\n");
    free_pages(p0, 4);
    cprintf("!!! 第五次释放 !!!\n");
    free_pages(p1, 2);
    cprintf("!!! 第六次释放 !!!\n");
    free_pages(p2, 1);
    show_buddy_array();

    cprintf("!!! 第七次分配-3 !!!\n");
    assert((p0 = alloc_pages(3)) != NULL);
    cprintf("!!! 第八次分配-3 !!!\n");
    assert((p1 = alloc_pages(3)) != NULL);
    cprintf("!!! 第七次释放 !!!\n");
    free_pages(p0, 3);
    cprintf("!!! 第八次释放 !!!\n");
    free_pages(p1, 3);

    show_buddy_array();
    cprintf("!!! 测试结束 !!!\n");
}

// 运行伙伴系统的测试
static void buddy_check(void) {
    basic_check();
}

// 定义伙伴系统的内存管理结构
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};
