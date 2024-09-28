# 题目：
## 练习1
### 题目：阅读 kern/init/entry.S内容代码，结合操作系统内核启动流程，说明指令 la sp, bootstacktop 完成了什么操作，目的是什么？ tail kern_init 完成了什么操作，目的是什么？
### 回答
+ la sp，bootstacktop 是一条地址加载指令。完成的操作是初始化内核栈指针sp，将bootsatcktop符号的地址加载到栈顶指针sp中；目的是将 bootstacktop 所表示的内存地址当作内核堆栈的顶部，以便在内核执行时正确。使用栈内存这条指令对内核堆栈空间进行了初始化。
+ tail kern_init 是一个尾调用指令。完成的操作是跳转到 kern_init 函数的代码块，以启动内核初始化流程；目的是完成内核初始化，kern_init 作为内核主体代码的入口，负责初始化内核。该指令的特点是调用后不会返回到调用者，控制流直接转向 kern_init 函数，从而执行真正的内核初始化过程。此外，由于尾调用的特性，调用者的栈帧不会被保留，这样可以节省空间并提高跳转效率。
## 拓展练习 Challenge2
### 题目：：在trapentry.S中汇编代码 csrw sscratch, sp；csrrw s0, sscratch, x0实现了什么操作，目的是什么？save all里面保存了stval scause这些csr，而在restore all里面却不还原它们？那这样store的意义何在呢？
### 回答
#### 在trapentry.S中汇编代码 csrw sscratch, sp；csrrw s0, sscratch, x0实现了什么操作，目的是什么？
在 trapentry.S 中，汇编代码 csrw sscratch, sp 和 csrrw s0, sscratch, x0 实现的操作是：
+ csrw sscratch, sp 将中断产生时的栈指针（sp）值保存到 sscratch 特权寄存器中，以避免在保存所有上下文期间修改 sp 值而导致的问题；
+ csrrw s0, sscratch, x0 将 sscratch 中的原 sp 值读取到通用寄存器 s0，并将 sscratch 清零。
其目的是通过临时保存 sp 值，以便在调用 trap 处理例程时作为参数传递。同时，保存 stval 和 scause 等 CSR 寄存器用于记录异常中断的来源信息，如异常的指令地址和原因等。
#### save all里面保存了stval scause这些csr，而在restore all里面却不还原它们？
在 save all 中保存这些 CSR 寄存器的意义在于提供处理异常所需的上下文信息，而在 restore all 中不还原这些 CSR 值是因为它们仅在异常处理期间使用，恢复任务上下文时并不相关。此外，下一次中断可能会覆盖这些 CSR 值，因此不需要恢复它们。
#### 那这样store的意义何在呢？
通过 CSR 的暂存和传值，实现了 sp 值的保存和利用，同时记录中断来源信息，这对异常处理和转入 trap 例程至关重要。即使不还原 CSR，记录的信息也已被充分利用。