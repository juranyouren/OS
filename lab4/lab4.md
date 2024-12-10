# Lab4 进程管理

小组成员：杨胜麟 米建伯 李昕杨

## 实验目的

+ 了解内核线程创建/执行的管理过程

+ 了解内核线程的切换和基本调度过程

## 练习

### 练习1：分配并初始化一个进程控制块（需要编码）

alloc_proc函数（位于kern/process/proc.c中）负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

> 【提示】在alloc_proc函数的实现中，需要初始化的proc_struct结构中的成员变量至少包括：state/pid/runs/kstack/need_resched/parent/mm/context/tf/cr3/flags/name。

```c++
// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
    //LAB4:EXERCISE1 2213130
    /*
     * below fields in proc_struct need to be initialized
     *       enum proc_state state;                      // Process state
     *       int pid;                                    // Process ID
     *       int runs;                                   // the running times of Proces
     *       uintptr_t kstack;                           // Process kernel stack
     *       volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
     *       struct proc_struct *parent;                 // the parent process
     *       struct mm_struct *mm;                       // Process's memory management field
     *       struct context context;                     // Switch here to run process
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */

    proc->state = PROC_UNINIT;
    proc->pid = -1;
    proc->runs = 0;
    proc->kstack = 0;
    proc->need_resched = 0;
    proc->parent = NULL;
    proc->mm = NULL;
    memset(&(proc->context), 0, sizeof(struct context));
    proc->tf = NULL;
    proc->cr3 = boot_cr3;
    proc->flags = 0;
    memset(proc->name, 0, PROC_NAME_LEN + 1);

    }
    return proc;
}
```

- 请说明proc_struct中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

```c++
struct proc_struct {
    enum proc_state state;                  // Process state
    int pid;                                // Process ID
    int runs;                               // the running times of Proces
    uintptr_t kstack;                       // Process kernel stack
    volatile bool need_resched;             // bool value: need to be rescheduled to release CPU?
    struct proc_struct *parent;             // the parent process
    struct mm_struct *mm;                   // Process's memory management field
    struct context context;                 // Switch here to run process
    struct trapframe *tf;                   // Trap frame for current interrupt
    uintptr_t cr3;                          // CR3 register: the base addr of Page Directroy Table(PDT)
    uint32_t flags;                         // Process flag
    char name[PROC_NAME_LEN + 1];           // Process name
    list_entry_t list_link;                 // Process link list 
    list_entry_t hash_link;                 // Process hash list
};
```



>- `context`：`context`中保存了进程执行的上下文，也就是几个关键的寄存器的值。这些寄存器的值用于在进程切换中还原之前进程的运行状态,在通过`proc_run`切换到CPU上运行时，需要调用`switch_to`将原进程的寄存器保存，以便下次切换回去时读出，保持之前的状态。
>- `tf`：`tf`里保存了进程的中断帧（32个通用寄存器、异常相关的寄存器）。当进程从用户空间跳进内核空间的时候，进程的执行状态被保存在了中断帧中（注意这里需要保存的执行状态数量不同于上下文切换）。系统调用可能会改变用户寄存器的值，我们可以通过调整中断帧来使得系统调用返回特定的值。比如可以利用`s0`和`s1`传递线程执行的函数和参数；在创建子线程时，会将中断帧中的`a0`设为`0`。

### 练习2：为新创建的内核线程分配资源（需要编码）

> 创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用**do_fork**函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块，但alloc_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。因此，我们**实际需要"fork"的东西就是stack和trapframe**。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中的do_fork函数中的处理过程。它的大致执行步骤包括：
>
> - 调用alloc_proc，首先获得一块用户信息块。
> - 为进程分配一个内核栈。
> - 复制原进程的内存管理信息到新进程（但内核线程不必做此事）
> - 复制原进程上下文到新进程
> - 将新进程添加到进程列表
> - 唤醒新进程
> - 返回新进程号

实现过程：

```c
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    //LAB4:EXERCISE2 2211448
    //    1. call alloc_proc to allocate a proc_struct
    proc = alloc_proc();
    if (proc == NULL) {
        goto fork_out;
    }
    //    2. call setup_kstack to allocate a kernel stack for child process
    ret = setup_kstack(proc);
    if (ret != 0) {
        goto bad_fork_cleanup_proc;
    }
    //    3. call copy_mm to dup OR share mm according clone_flag
     ret = copy_mm(clone_flags, proc);
    if (ret != 0) {
        goto bad_fork_cleanup_kstack;
    }
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
    //    5. insert proc_struct into hash_list && proc_list
    proc->pid = get_pid();
    hash_proc(proc);
    list_add(&proc_list, &(proc->list_link));
    nr_process ++;
    //    6. call wakeup_proc to make the new child process RUNNABLE
    
    wakeup_proc(proc);
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
    

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```

### Q:请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

#### get_pid()函数分析

1. **初始化 `last_pid` 和 `next_safe`**：

   ```c
   static int next_safe = MAX_PID, last_pid = MAX_PID;
   ```

   `last_pid` 用来存储上一个分配的 PID，`next_safe` 用来追踪当前最小的未被占用的 PID。初始化时，它们都设置为 `MAX_PID`，表示 PID 分配的起始点。

2. **判断是否需要从头开始分配 PID**：

   ```c
   if (++ last_pid >= MAX_PID) {
       last_pid = 1;
       goto inside;
   }
   ```

   如果 `last_pid` 超过了 `MAX_PID`，就从 `1` 开始分配 PID。`MAX_PID` 是系统允许的最大 PID。`goto inside;` 会跳转到一个新的检查过程，确保下一个 PID 分配安全。

3. **判断是否需要更新 `next_safe`**：

   ```c
   if (last_pid >= next_safe) {
       inside:
       next_safe = MAX_PID;
   ```

   如果 `last_pid` 超过了 `next_safe`，就意味着可能有 PID 被占用，需要重新检查 PID 分配情况。此时 `next_safe` 被重置为 `MAX_PID`。

4. **遍历进程链表检查 PID 是否被占用**：

   ```c
   le = list;
   while ((le = list_next(le)) != list) {
       proc = le2proc(le, list_link);
   ```

   这一部分遍历所有已存在的进程（通过 `proc_list` 链表存储），逐个检查每个进程的 PID 是否与当前分配的 `last_pid` 相同。

5. **PID 已占用的处理**：

   ```c
   if (proc->pid == last_pid) {
       if (++ last_pid >= next_safe) {
           if (last_pid >= MAX_PID) {
               last_pid = 1;
           }
           next_safe = MAX_PID;
           goto repeat;
       }
   }
   ```

   如果 `last_pid` 被某个进程占用，则递增 `last_pid`，继续检查下一个 PID。若 `last_pid` 超过了 `next_safe`，重新开始 PID 查找。

6. **更新 `next_safe`**：

   ```c
   else if (proc->pid > last_pid && next_safe > proc->pid) {
       next_safe = proc->pid;
   }
   ```

   如果当前进程的 PID 大于 `last_pid`，并且 `next_safe` 大于当前进程的 PID，那么更新 `next_safe`，以便在下次查找时可以跳过已占用的 PID。

7. **返回可用的 PID**：

   ```c
   return last_pid;
   ```

   如果找到了未被占用的 PID，返回该 PID。该 PID 就是新进程将要分配的唯一标识符。

#### `get_pid()` 为什么确保 PID 唯一？

- **线性递增**：`get_pid()` 函数通过递增 `last_pid` 来查找下一个可用的 PID，这样可以确保 PID 在一个有序的范围内分配。
- **遍历检查**：通过遍历 `proc_list`，确保每个分配的 PID 是唯一的。若发现有进程占用了当前的 PID，`last_pid` 会递增，直到找到一个未被占用的 PID。
- **PID 回收**：由于使用了 `next_safe` 来追踪最小的未被占用 PID，因此当某个 PID 被回收时，它会被及时地重新利用。

#### 如果没有 `next_safe` 会怎样？

如果没有 `next_safe`，就没有办法提前知道下一个最小的未占用 PID。在这种情况下，`get_pid()` 将只能依赖于简单的递增方式（通过 `last_pid`），这意味着每次都必须遍历所有进程来查找一个有效的 PID。这样会导致性能下降，特别是当系统中的进程数非常多时。

使用 `next_safe` 可以减少不必要的遍历，使得查找 PID 的效率更高。它起到了一个加速器的作用，让系统能够快速跳过已经被占用的 PID，从而提高 PID 分配的效率。

### 练习3：编写`proc_run `函数（需要编码）

> `proc_run`用于将指定的进程切换到CPU上运行。它的大致执行步骤包括：
>
> - 检查要切换的进程是否与当前正在运行的进程相同，如果相同则不需要切换。
> - 禁用中断。你可以使用`/kern/sync/sync.h`中定义好的宏`local_intr_save(x)`和`local_intr_restore(x)`来实现关、开中断。
> - 切换当前进程为要运行的进程。
> - 切换页表，以便使用新进程的地址空间。`/libs/riscv.h`中提供了`lcr3(unsigned int cr3)`函数，可实现修改CR3寄存器值的功能。
> - 实现上下文切换。`/kern/process`中已经预先编写好了`switch.S`，其中定义了`switch_to()`函数。可实现两个进程的context切换。
> - 允许中断。

函数实现：

```
void
proc_run(struct proc_struct *proc) {
    if (proc != current) {
        //检查当前正在运行的进程与将要切换的进程是否一致，如果一致就不切换了
        
        // LAB4:EXERCISE3 YOUR CODE
        /*
        * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
        * MACROs or Functions:
        *   local_intr_save():        Disable interrupts
        *   local_intr_restore():     Enable Interrupts
        *   lcr3():                   Modify the value of CR3 register
        *   switch_to():              Context switching between two processes
        */
       //切换进程
       //禁用中断
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        // 关闭中断,进行进程切换
        local_intr_save(intr_flag);
        {
            //当前进程设为待调度的进程
            current = proc;
            //将当前的cr3寄存器改为需要运行进程的页目录表
            lcr3(next->cr3);
            //进行上下文切换，保存原线程的寄存器并恢复待调度线程的寄存器
            switch_to(&(prev->context), &(next->context));
        }
        //恢复中断
        local_intr_restore(intr_flag);


    }
}
```

### Q:在本实验的执行过程中，创建且运行了几个内核线程？

在本实验中，创建且运行了2两个内核线程：

①`idleproc`：第一个内核进程，完成内核中各个子系统的初始化，之后立即调度，执行其他进程。

②`initproc`：用于完成实验的功能而调度的内核进程。

## Challenge

- 说明语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`是如何实现开关中断的?

```c++
// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
    if (proc != current) {
        //检查当前正在运行的进程与将要切换的进程是否一致，如果一致就不切换了
        
        // LAB4:EXERCISE3 YOUR CODE
        /*
        * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
        * MACROs or Functions:
        *   local_intr_save():        Disable interrupts
        *   local_intr_restore():     Enable Interrupts
        *   lcr3():                   Modify the value of CR3 register
        *   switch_to():              Context switching between two processes
        */
       //切换进程
       //禁用中断
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        // 关闭中断,进行进程切换
        local_intr_save(intr_flag);
        {
            //当前进程设为待调度的进程
            current = proc;
            //将当前的cr3寄存器改为需要运行进程的页目录表
            lcr3(next->cr3);
            //进行上下文切换，保存原线程的寄存器并恢复待调度线程的寄存器
            switch_to(&(prev->context), &(next->context));
        }
        //恢复中断
        local_intr_restore(intr_flag);


    }
}
```

```c++
static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
        intr_disable();
        return 1;
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

#define local_intr_save(x) \
    do {                   \
        x = __intr_save(); \
    } while (0)
#define local_intr_restore(x) __intr_restore(x);
```

当调用`local_intr_save`时，会读取`sstatus`寄存器，判断`SIE`位的值，如果该位为1，则说明中断是能进行的，这时需要调用`intr_disable`将该位置0，并返回1，将`intr_flag`赋值为1；如果该位为0，则说明中断此时已经不能进行，则返回0，将`intr_flag`赋值为0。以此保证之后的代码执行时不会发生中断。

当需要恢复中断时，调用`local_intr_restore`，需要判断`intr_flag`的值，如果其值为1，则需要调用`intr_enable`将`sstatus`寄存器的`SIE`位置1，否则该位依然保持0。以此来恢复调用`local_intr_save`之前的`SIE`的值。