1.操作系统的基本特征
并发：并发是指宏观上在一段时间内能同时运行多个程序，而并行则指同一时刻能运行多个指令。
操作系统通过引入进程和线程，使得程序能够并发运行。并行需要硬件支持。

共享：指系统中的资源可以被多个并发进程共同使用。
有两种共享方式：互斥共享和同时共享。互斥共享的资源称为临界资源。

虚拟：虚拟技术把一个物理实体转换为多个逻辑实体。
主要有两种虚拟技术：时分复用技术和空（空间）分复用技术。

异步：异步指进程不是一次性执行完毕，而是走走停停，以不可知的速度向前推进。

2.操作系统的基本功能
进程管理：进程控制、进程同步、进程通信、死锁处理、处理机调度等。
内存管理：内存分配、地址映射、内存保护与共享、虚拟内存等。
文件管理：文件存储空间的管理、目录管理、文件读写管理和保护等。
设备管理：缓冲管理、设备分配、设备处理、虛拟设备等。

3.进程与线程
进程：
进程是资源分配的基本单位。
进程控制块PCB：描述进程的基本信息和运行状态，创建进程和撤销进程都是指对PCB的操作。 
进程状态以及转换：运行，就绪，阻塞（三种进程的基本状态），新建，终止。就绪和运行可以互相切换，其余不行。
程序是静态的代码，而进程是程序的一次执行过程，是系统运行程序的基本单位，因此进程是动态的。

线程：
线程是独立调度的基本单位。一个进程中可以有多个线程，它们共享进程的堆和方法区资源，但每个线程有自己的程序计数器、虚拟机栈和本地方法栈。
堆是进程中最大的一块内存，主要用于存放新创建的对象 (所有对象都在这里分配内存)，方法区主要用于存放已被加载的类信息、常量、静态变量、即时编译器编译后的代码等数据。
程序计数器私有主要是为了线程切换后能恢复到正确的执行位置。
虚拟机栈和本地方法栈私有主要是为了保证线程中的局部变量不被别的线程访问到。

进程和线程的区别：
1.进程是资源分配的基本单位，但是线程不拥有资源，线程可以访问隶属进程的资源。
2.线程是独立调度的基本单位，在同一进程中，线程的切换不会引起进程切换，从一个进程中的线程切换到另一个进程中的线程时，会引起进程切换。
3.创建和撤销进程，和在进行进程切换时，开销大于线程。
4.线程间可以通过直接读写同一进程中的数据进行通信，但是进程通信需要借助IPC。
5.多进程程序更健壮，多线程程序只要有一个线程死掉，整个进程也死掉了，而一个进程死掉并不会对另外一个进程造成影响，因为进程有自己独立的地址空间。

进程线程模型
内核线程：内核线程就是内核的分身，一个分身可以处理一件特定事情。这在处理异步事件如异步IO时特别有用。内核线程的使用是廉价的，唯一使用的资源就是内核栈和上下文切换时保存寄存器的空间。
用户线程：用户线程是完全建立在用户空间的线程库，用户线程的创建、调度、同步和销毁全又库函数在用户空间完成，不需要内核的帮助。因此这种线程是极其低消耗和高效的。
轻量级进程LWP：建立在内核之上并由内核支持的用户线程，它是内核线程的高度抽象，每一个轻量级进程都与一个特定的内核线程关联。内核线程只能由内核管理并像普通进程一样被调度。

4.进程调度
不同环境的调度算法目标不同。

批处理系统：没有太多的用户操作，在该系统中，调度算法目标是保证吞吐量和周转时间。
1.先来先服务FCFS：非抢占式的调度算法，按照请求的顺序进行调度。有利于长作业，但不利于短作业。
2.短作业优先SJF：非抢占式的调度算法，按估计运行时间最短的顺序进行调度。如果一直有短作业到来，那么长作业永远得不到调度。
3.最短剩余时间优先SRTN：短作业优先的抢占式版本，按剩余运行时间的顺序进行调度。当一个新的作业到达时，其整个运行时间与当前进程的剩余时间作比较。如果新的进程需要的时间更少，则挂起当前进程，运行新的进程。否则新的进程等待。
4.高响应比优先：FCFS和SJF的综合平衡。

交互式系统：有大量的用户交互操作，在该系统中调度算法的目标是快速地进行响应。
1.时间片轮转：将所有就绪进程按FCFS的原则排成一个队列，每次调度时，把 CPU 时间分配给队首进程，当时间片用完时，由计时器发出时钟中断，调度程序便停止该进程的执行，并将它送往就绪队列的末尾，同时继续把 CPU 时间分配给队首的进程。
时间片轮转算法的效率和时间片的大小有很大关系。
2.优先级调度：为了防止低优先级的进程永远等不到调度，可以随着时间的推移增加等待进程的优先级。
3.多级反馈队列：设置了多个队列，每个队列时间片大小都不同，看成是时间片轮转调度算法和优先级调度算法的结合。

5.进程同步
临界区：对临界资源进行访问的那段代码称为临界区。为了互斥访问临界资源，每个进程在进入临界区之前，需要先进行检查。
同步：多个进程按一定顺序执行；互斥：多个进程在同一时刻只有一个进程能进入临界区。
管程：把控制的代码独立出来。管程有一个重要特性：在一个时刻只能有一个进程使用管程。

信号量Semaphore：
down和up操作，也就是常见的P和V操作。down和up操作设计成原语，不可分割，通常的做法是在执行这些操作的时候屏蔽中断。
如果信号量的取值只能为0或者1，那么就成为了互斥量Mutex，0表示临界区已经加锁，1表示临界区解锁。
用信号量实现生产者-消费者问题：对empty和full变量的P操作必须在mutex的P操作之前。

经典同步问题：
生产者和消费者问题。
读者-写者问题：允许多个进程同时对数据进行读操作，但是不允许读和写以及写和写操作同时发生。
哲学家进餐问题。
吸烟者问题。

6.进程通信
管道：只支持半双工通信，只能在父子进程中使用。
命名管道FIFO：去除了管道只能在父子进程中使用的限制。用作汇聚点，在客户进程和服务器进程之间传递数据。FIFO有路径名与之相关联，它以一种特殊设备文件形式存在于文件系统中。

消息队列：消息的链接表，存放在内核中。一个消息队列由一个标识符（即队列ID）来标识。
特点：面向记录，其中的消息具有特定的格式以及特定的优先级；独立于发送与接收进程。进程终止时，消息队列及其内容并不会被删除；以实现消息的随机查询,消息不一定要以先进先出的次序读取,也可以按消息的类型读取。

消息队列相比FIFO的优点：
消息队列可以独立于读写进程存在，从而避免了FIFO中同步管道的打开和关闭时可能产生的困难；
避免了FIFO的同步阻塞问题，不需要进程自己提供同步方法；
读进程可以根据消息类型有选择地接收消息，而不像FIFO那样只能默认地接收。

信号量：一个计数器，用于为多个进程提供对共享数据对象的访问，实现进程间的互斥与同步。若要在进程间传递数据需要结合共享存储。
共享存储：允许多个进程共享一个给定的存储区，数据不需要在进程之间复制，所以这是最快的一种IPC。需要使用信号量用来同步对共享存储的访问。多个进程可以将同一个文件映射到它们的地址空间从而实现共享内存。
套接字：可用于不同机器间的进程通信。

五种方式总结：
管道：速度慢，容量有限，只有父子进程能通讯    
FIFO：任何进程间都能通讯，但速度慢    
消息队列：容量受到系统限制，且要注意第一次读的时候，要考虑上一次没有读完数据的问题    
信号量：不能传递复杂消息，只能用来同步    
共享内存区：能够很容易控制容量，速度快，但要保持同步

7.死锁
必要条件：互斥，请求和占有，不可抢占，循环等待。

处理方法：
1.鸵鸟策略：假装根本没发生问题。因为解决死锁问题的代价很高，因此鸵鸟策略这种不采取任务措施的方案会获得更高的性能。当发生死锁时不会对用户造成多大影响，或发生死锁的概率很低，可以采用鸵鸟策略。
2.死锁检测与恢复：不试图阻止死锁，而是当检测到死锁发生时，采取措施进行恢复。 
3.死锁预防：破坏死锁发生的必要条件。
4.死锁避免：在程序运行时避免发生死锁。安全状态，银行家算法（单个资源和多个资源）。
加锁顺序：如果能确保所有的线程都是按照相同的顺序获得锁，那么死锁就不会发生。
加锁时限：在尝试获取锁的时候加一个超时时间，这也就意味着在尝试获取锁的过程中若超过了这个时限该线程则放弃对该锁请求。若一个线程没有在给定的时限内成功获得所有需要的锁，则会进行回退并释放所有已经获得的锁，然后等待一段随机的时间再重试。这段随机的等待时间让其它线程有机会尝试获取相同的这些锁，并且让该应用在没有获得锁的时候可以继续运行。

活锁是指进程互相谦让，都释放资源给别的进程，导致资源在进程之间跳动但是进程却一直不执行。
饥饿是指将低优先级的进程长时间请求不到所需要的资源。但是饥饿中进程最后可以请求到资源，只要不再有高优先级的进程使用资源，这和死锁有所不同。

8.内存管理
虚拟内存：为了让物理内存扩充成更大的逻辑内存，从而让程序获得更多的可用内存。
虚拟内存允许程序不用将地址空间中的每一页都映射到物理内存，也就是说一个程序不需要全部调入内存就可以运行。
一个虚拟地址分成两个部分，一部分存储页面号，一部分存储偏移量。虚拟内存采用的是分页技术。

分页与分段：内存中都是不连续的
分页：将地址空间划分成固定大小的页，每一页再与内存进行映射。
分段：分段的做法是把每个表分成段，一个段构成一个独立的地址空间。每个段的长度可以不同，并且可以动态增长。
段页式：程序的地址空间划分成多个拥有独立地址空间的段，每个段上的地址空间划分成大小相同的页。这样既拥有分段系统的共享和保护，又拥有分页系统的虚拟内存功能。

分页与分段的比较：
页是物理单位，出于系统管理需要；而段是逻辑单位，出于用户需要。
页的大小固定且由系统决定，由系统把逻辑地址划分为页号和页内地址；段的大小可以动态改变，既要给出段名，又要给出段内地址。
分页是一维地址空间，分段是二维的。

9.页面置换算法
在程序运行过程中，如果要访问的页面不在内存中，就发生缺页中断从而将该页调入内存中。此时如果内存已无空闲空间，系统必须从内存中调出一个页面到磁盘对换区中来腾出空间。
页面置换算法的主要目标是使页面置换频率最低（也可以说缺页率最低）。

最佳OPT：所选择的被换出的页面将是最长时间内不再被访问，通常可以保证获得最低的缺页率。
最近最久未使用LRU：链表。
最近未使用NRU
先进先出FIFO：该算法会将那些经常被访问的页面也被换出，从而使缺页率升高。
第二次机会算法：避免了FIFO可能会把经常使用的页面置换出去的问题。
时钟：环形链表。

10.静态链接和动态链接
静态链接的缺点：生成的可执行文件较大；当静态库更新时整个程序都要重新进行链接；重复代码太多。
动态链接：共享库可以被不同的正在运行的进程共享。
