### 练习

对实验报告的要求：
 - 基于markdown格式来完成，以文本方式为主
 - 填写各个基本练习中要求完成的报告内容
 - 完成实验后，请分析ucore_lab中提供的参考答案，并请在实验报告中说明你的实现与参考答案的区别
 - 列出你认为本实验中重要的知识点，以及与对应的OS原理中的知识点，并简要说明你对二者的含义，关系，差异等方面的理解（也可能出现实验中的知识点没有对应的原理知识点）
 - 列出你认为OS原理中很重要，但在实验中没有对应上的知识点

## 练习0：填写已有实验

本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有“LAB1”的注释相应部分并按照实验手册进行进一步的修改。具体来说，就是跟着实验手册的教程一步步做，然后完成教程后继续完成完成exercise部分的剩余练习。

## 练习1：理解first-fit 连续物理内存分配算法（思考题）
first-fit 连续物理内存分配算法作为物理内存分配一个很基础的方法，需要同学们理解它的实现过程。请大家仔细阅读实验手册的教程并结合`kern/mm/default_pmm.c`中的相关代码，认真分析default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数，并描述程序在进行物理内存分配的过程以及各个函数的作用。
请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 你的first fit算法是否有进一步的改进空间？

  ------

### default_init

```c
static void default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
```

#### 1.函数分析

1. **`list_init(&free_list);`**：将 `free_list` 的前向和后向指针都指向自己，形成一个空的双向链表。`free_list` 被用作链表头，用来链接所有的空闲页。
   
2. **`nr_free = 0;`**：`nr_free` 用来记录系统中当前空闲的物理页数量。初始状态下，系统尚未标识任何物理页为空闲，因此 `nr_free` 设置为 0。

#### 2.函数作用

`default_init` 函数的作用是为内存管理器的空闲页管理部分进行基础初始化。

1. **初始化空闲链表**：将 `free_list` 链表初始化为空，表示没有空闲页加入链表。
2. **初始化空闲页计数器**：将 `nr_free` 设置为 0，表示系统中没有标记空闲的物理页。

`default_init_memmap` 函数的主要作用是初始化一块连续的物理页，使其能够被操作系统用于内存分配。它将这块内存页标记为空闲页并加入到空闲页的管理链表中，以便后续的分配和释放操作。以下是对该函数的详细分析：

### default_init_memmap

```c
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;

    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
}
```

#### 1.函数分析

1. **`assert(n > 0);`**：初始化的页数 `n` 大于 0。
   
2. **`struct Page *p = base;`**：定义一个指针 `p`，用于遍历从 `base` 开始的连续页区域。
   
3. **遍历并初始化每个 `Page` 结构体**：
   ```c
   for (; p != base + n; p++) {
       assert(PageReserved(p));
       p->flags = p->property = 0;
       set_page_ref(p, 0);
   }
   ```
   - 确保当前页 `p` 是被保留的（`PageReserved(p)`）。表示这些页在初始化之前是已经被内核标记为保留的状态。
   - 将当前页的 `flags` 和 `property` 清零。
   - 调用 `set_page_ref(p, 0)`，将页的引用计数设置为 0，表示当前没有对象引用这块页。
   
4. **设置base的属性**：
   
   ```c
   base->property = n;
   SetPageProperty(base);
   nr_free += n;
   ```
   - 将当前内存块的`base`的 `property` 设置为 `n`，表示该头部页管理 `n` 个连续的空闲页。
   - **`SetPageProperty`**：设置该页的 `PageProperty` 标志位，表示这是一个空闲页块的`base`。
   - **更新空闲页计数器 `nr_free`**：增加 `n`，表示系统中现在空闲页+n。
   
5. **将初始化的页块插入 `free_list` 中**：
   
   ```c
   if (list_empty(&free_list)) {
       list_add(&free_list, &(base->page_link));
   } else {
       list_entry_t* le = &free_list;
       while ((le = list_next(le)) != &free_list) {
           struct Page* page = le2page(le, page_link);
           if (base < page) {
               list_add_before(le, &(base->page_link));
               break;
           } else if (list_next(le) == &free_list) {
               list_add(le, &(base->page_link));
           }
       }
   }
   ```
   - 检查空闲链表是否为空。如果为空，则直接将页块插入链表。
   - 如果链表不为空，遍历链表，找到 `base` 小于链表中的某个 `page`，然后将 `base` 插入到该位置之前。如果遍历完链表都没有找到合适的位置，则将 `base` 插入到链表末尾。

#### 2.函数作用

1. **初始化一块连续的物理页**：将从 `base` 开始的 `n` 个连续的物理页进行初始化，将它们的状态、属性、引用计数等清零，以表示这块内存页可以被系统用于内存分配。
2. **设置base的属性**：将页块的base标记为管理 `n` 个连续空闲页，并更新空闲页的数量。
3. **将页块插入空闲链表**：将新的空闲页块插入到空闲页链表 `free_list` 中。

`default_alloc_pages` 函数的主要作用是根据 First-Fit 策略，从空闲页链表中分配至少 `n` 个连续的物理页。该函数会遍历空闲页链表，找到第一个足够大的空闲页块进行分配，并在成功分配后更新链表和空闲页计数器。

### default_alloc_pages

```c
static struct Page *default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        list_entry_t* prev = list_prev(&(page->page_link));
        list_del(&(page->page_link));
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            SetPageProperty(p);
            list_add(prev, &(p->page_link));
        }
        nr_free -= n;
        ClearPageProperty(page);
    }
    return page;
}
```

#### 1.函数分析

1. **`assert(n > 0);`**：确保请求的页数 `n` 大于 0。
   
2. **检查空闲页数量 `nr_free`**：
   ```c
   if (n > nr_free) {
       return NULL;
   }
   ```
   如果请求的页数 `n` 大于当前空闲页的数量 `nr_free`，则无法满足请求，直接返回 `NULL`。**遍历空闲链表，寻找合适的页块**：

   ```c
   struct Page *page = NULL;
   list_entry_t *le = &free_list;
   while ((le = list_next(le)) != &free_list) {
       struct Page *p = le2page(le, page_link);
       if (p->property >= n) {
           page = p;
           break;
       }
   }
   ```
   - 遍历空闲链表 `free_list`，寻找第一个满足条件的页块 `p`，即 `p->property >= n`。这意味着页块 `p` 拥有的连续空闲页数大于或等于请求的页数 `n`。
   - **`list_next`** 用于获取链表中的下一个节点，`le2page` 用于将链表节点转换为对应的 `Page` 结构体。
   
4. **分配页块**：
   ```c
   if (page != NULL) {
       list_entry_t* prev = list_prev(&(page->page_link));
       list_del(&(page->page_link));
       if (page->property > n) {
           struct Page *p = page + n;
           p->property = page->property - n;
           SetPageProperty(p);
           list_add(prev, &(p->page_link));
       }
       nr_free -= n;
       ClearPageProperty(page);
   }
   ```
   - 如果找到符合条件的页块 `page`，则执行分配操作。
     - 记录当前页块的前一个链表节点 `prev`。
     - 从空闲链表中删除找到的页块 `page`。
     - 如果找到的页块 `page` 的 `property` 大于 `n`，则需要将剩余的空闲页重新加入到链表中：
       - 计算剩余空闲页的起始地址 `p`（即 `page + n`）。
       - 将剩余页的 `property` 设置为 `page->property - n`，表示剩余的空闲页数量。
       - 设置 `p` 为属性页（`SetPageProperty`），并将其加入到空闲链表中。
     - 更新空闲页计数器 `nr_free`，减少 `n`。
     - 清除找到的页块 `page` 的 `PageProperty` 标志，表示这些页已被分配。

#### 2.函数作用

`default_alloc_pages` 函数的主要作用是使用First-Fit 算法进行内存分配。

1. **遍历空闲页链表**：从链表的起始位置开始，寻找第一个可以满足请求的空闲页块。
2. **执行内存分配**：当找到合适的空闲页块后，根据请求的页数 `n`，将该空闲页块从链表中移除，并更新页块的状态。
3. **更新空闲页状态**：在成功分配内存后，更新空闲页链表和空闲页计数器 `nr_free`，记录剩余的空闲页信息。

`default_free_pages` 函数的主要作用是将已经分配的 `n` 个连续物理页释放，并将它们重新加入到空闲页链表中。该函数不仅要将这些页标记为空闲，还要尽可能地将相邻的空闲页合并，以减少内存碎片。

### default_free_pages

```c
static void default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;

    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }

    // 合并相邻的空闲页
    list_entry_t* le = list_prev(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            list_del(&(base->page_link));
            base = p;
        }
    }

    le = list_next(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
    }
}
```

#### 1.函数分析

1. **参数和初始检查**：
   ```c
   assert(n > 0);
   struct Page *p = base;
   ```
   - 确保释放的页数 `n` 大于 0。`base` 是要释放的连续页的起始地址。

2. **遍历并重置每个 `Page` 的状态**：
   ```c
   for (; p != base + n; p++) {
       assert(!PageReserved(p) && !PageProperty(p));
       p->flags = 0;
       set_page_ref(p, 0);
   }
   ```
   - 遍历从 `base` 开始的每个 `Page`，确保这些页没有被保留且不属于其他内存块的头部页。
   
3. **设置头部页的属性**：
   ```c
   base->property = n;
   SetPageProperty(base);
   nr_free += n;
   ```
   - 将 `base` 页的 `property` 设置为 `n`，表示这块内存页的头部页拥有 `n` 个连续的空闲页。标记该页为属性页，并更新空闲页计数器 `nr_free`。

4. **将新释放的页块插入空闲链表**：
   
   ```c
   if (list_empty(&free_list)) {
       list_add(&free_list, &(base->page_link));
   } else {
       list_entry_t* le = &free_list;
       while ((le = list_next(le)) != &free_list) {
           struct Page* page = le2page(le, page_link);
           if (base < page) {
               list_add_before(le, &(base->page_link));
               break;
           } else if (list_next(le) == &free_list) {
               list_add(le, &(base->page_link));
           }
       }
   }
   ```
   - 将新的空闲页块插入到空闲链表 `free_list` 中。
   
5. **合并相邻的空闲页块：**
   
   ```c
   list_entry_t* le = list_prev(&(base->page_link));
   if (le != &free_list) {
       p = le2page(le, page_link);
       if (p + p->property == base) {
           p->property += base->property;
           ClearPageProperty(base);
           list_del(&(base->page_link));
           base = p;
       }
   }
   ```
   - 向前合并相邻的空闲页块。如果 `base` 页的前一个页块 `p` 与 `base` 相邻，则将 `p` 的 `property` 加上 `base` 的 `property`，并清除 `base` 页的属性标志位，将其从链表中删除。
   
   ```c
   le = list_next(&(base->page_link));
   if (le != &free_list) {
       p = le2page(le, page_link);
       if (base + base->property == p) {
           base->property += p->property;
           ClearPageProperty(p);
           list_del(&(p->page_link));
       }
   }
   ```
   - 向后合并相邻的空闲页块。

#### 2.函数作用

`default_free_pages` 函数的主要作用是：

1. **标记释放的页为空闲**：将一段连续的物理页从已分配状态转换为空闲状态。
2. **插入空闲链表**：将新释放的页块插入到空闲链表 `free_list` 中，并确保链表的有序性。
3. **合并相邻的空闲页块**：在释放页块的过程中，尽可能地与前后相邻的空闲页块合并，减少内存碎片。

### 物理内存分配的过程

1. **初始化**：通过 `default_init` 和 `default_init_memmap` 函数，将空闲页链表和空闲页的基本信息初始化，并将可用的物理页标记为空闲，加入到空闲链表中。
2. **分配页**：在 `default_alloc_pages` 函数中，根据 First-Fit 遍历空闲页链表，找到第一个满足大小要求的空闲页块，将其从链表中取出并返回给调用者。
3. **释放页**：在 `default_free_pages` 函数中，将要释放的页块插入到空闲页链表中，并尝试合并相邻的空闲页块，以保持内存的连续性。

### First-Fit改进方向：

#### 1. **改进合并相邻空闲页块的策略**
 `default_free_pages` 函数在释放页时只尝试与前后相邻的页块进行合并。

**改进建议**：
- **批量合并**：在释放多个页块时，批量检查并合并所有相邻的空闲块，减少合并操作的次数。
- **延迟合并**：在某些情况下，可以延迟合并操作，将其放在空闲时机较好的时候进行，以减少频繁的合并开销。

#### 2. **使用更高效的数据结构管理空闲块**
**改进建议**：

- **红黑树**：使用红黑树来管理空闲块，可以在对数时间内完成插入、删除和查找操作，提升整体性能。
- **位图**：使用位图来表示内存页的使用状态，可以更高效地进行内存查找和管理。

## 练习2：实现 Best-Fit 连续物理内存分配算法（需要编程）
在完成练习一后，参考kern/mm/default_pmm.c对First Fit算法的实现，编程实现Best Fit页面分配算法，算法的时空复杂度不做要求，能通过测试即可。
请在实验报告中简要说明你的设计实现过程，阐述代码是如何对物理内存进行分配和释放，并回答如下问题：

- 你的 Best-Fit 算法是否有进一步的改进空间？

### 实现Best-Fit 算法：

相较于练习1中的First-Fit算法，只需要修改alloc_pages这一部分，修改内容如下：

```c
 size_t min_size = nr_free + 1;
     /*LAB2 EXERCISE 2: 2211448*/ 
    // 下面的代码是first-fit的部分代码，请修改下面的代码改为best-fit
    // 遍历空闲链表，查找满足需求的空闲页框
    // 如果找到满足需求的页面，记录该页面以及当前找到的最小连续空闲页框数量
    

while ((le = list_next(le)) != &free_list) {
    struct Page *p = le2page(le, page_link);
    if(p->property >= n && p->property <min_size) 
   {
        page = p;
        min_size=p->property;
        
    }
}
```

min_size：记录当前找到的最小连续空闲页框数量

**满足需求的页面：连续空闲页框数量>=n&&<当前找到的最小连续空闲页框数量**

### Best-Fit 算法的改进空间

1. **时间复杂度优化**：
   - **当前实现**：Best-Fit 需要遍历整个空闲链表以找到最优块，时间复杂度为 O(n)。
   - **改进**：可以采用红黑树来加速最优块的查找过程，将时间复杂度降低至 O(log n)。
2. **空闲块管理优化**：
   - **分级空闲链表**：将空闲块按照大小分级管理，使用多个空闲链表，每个链表负责特定大小范围的空闲块，从而减少查找时间。
   - **内存分区**：将内存划分为多个区域，每个区域使用不同的分配策略，针对不同大小的请求选择最合适的分配策略。
3. **合并策略优化**：
   - **延迟合并**：在释放页框时，不立即合并相邻块，而是延迟合并，以减少频繁的合并操作，提高释放效率。

#### 扩展练习Challenge：buddy system（伙伴系统）分配算法（需要编程）

Buddy System算法把系统中的可用存储空间划分为存储块(Block)来进行管理, 每个存储块的大小必须是2的n次幂(Pow(2, n)), 即1, 2, 4, 8, 16, 32, 64, 128...

 -  参考[伙伴分配器的一个极简实现](http://coolshell.cn/articles/10427.html)， 在ucore中实现buddy system分配算法，要求有比较充分的测试用例说明实现的正确性，需要有设计文档。

#### 扩展练习Challenge：任意大小的内存单元slub分配算法（需要编程）

slub算法，实现两层架构的高效内存单元分配，第一层是基于页大小的内存分配，第二层是在第一层基础上实现基于任意大小的内存分配。可简化实现，能够体现其主体思想即可。

 - 参考[linux的slub分配算法/](http://www.ibm.com/developerworks/cn/linux/l-cn-slub/)，在ucore中实现slub分配算法。要求有比较充分的测试用例说明实现的正确性，需要有设计文档。

#### 扩展练习Challenge：硬件的可用物理内存范围的获取方法（思考题）
  - 如果 OS 无法提前知道当前硬件的可用物理内存范围，请问你有何办法让 OS 获取可用物理内存范围？


> Challenges是选做，完成Challenge的同学可单独提交Challenge。完成得好的同学可获得最终考试成绩的加分。