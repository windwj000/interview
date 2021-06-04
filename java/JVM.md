## 简介

JVM 是一个可以执行 Java 字节码的虚拟机。

**Java 程序编译解释过程**

1. Java 程序 .java 先经过编译器 javac 编译成字节码文件 .class，.class 与平台无关。

2. .class 再运行在 JVM 上，作为 JVM 的一部分的 Java 解释器会将其解释成对应平台的二进制机器码执行。

**平台无关性**

在计算机上的运行不受平台的约束，一次编译，到处执行，减少了开发和部署到多个平台的成本和时间。JVM 在此充当了桥梁。还需要 Java 语言规范的配合。

JVM 本身不跨平台，不同操作系统下有不同版本的虚拟机，相当于屏蔽了底层操作系统和硬件的差异（不同的硬件和操作系统，最主要的区别就是指令不同）。

**语言无关性**

JVM 运行的时候，并不依赖于 Java 语言，而是和 Class 文件交互。如 Groovy、Scala、Jython 等都可以被编译成 Class 文件，然后在 JVM 上运行。



## 1.运行时数据区域（Java 内存区域）

**线程私有**

生命周期和线程相同，线程结束之后就会消失

#### 程序计数器

记录正在执行的虚拟机字节码指令的地址。如果执行的是 Native 方法，那么程序计数器记录的是 undefined 地址。

程序计数器私有，主要是为了线程切换后能恢复到正确的执行位置，各线程互不影响。

占用的内存空间小。

程序计数器是唯一一个不会出现 OutOfMemoryError 的内存区域。

**作用**

- 字节码解释器通过改变程序计数器来依次读取指令，从而实现代码的流程控制，如：顺序执行、选择、循环、异常处理。
- 在多线程的情况下，程序计数器用于记录当前线程执行的位置，从而当线程被切换回来的时候能够知道该线程上次运行到哪儿了（线程恢复）。

#### 虚拟机栈

每个 Java 方法在执行的同时会创建一个栈帧用于存储局部变量表、操作数栈、常量池引用等信息。

从方法调用直至执行完成（return 语句返回或抛出异常返回）的过程，对应着一个栈帧在 Java 虚拟机栈中入栈和出栈的过程。

Java 内存可以粗糙的区分为堆内存和栈内存，其中栈就是现在说的虚拟机栈，或者说是虚拟机栈中局部变量表部分。局部变量表主要存放了编译器可知的各种基本数据类型和对象引用。

局部变量表所需的内存空间在方法编译时就会完成分配，在方法运行时不会改变大小。

方法中的局部变量一定是在栈中运行的，一旦超出作用域，立刻从栈中消失。

栈私有，为了保证线程中的局部变量不被别的线程访问到。

**异常**

当线程请求的栈深度超过最大值，会抛出 StackOverflowError 异常。

栈进行动态扩展时如果无法申请到足够内存，会抛出 OutOfMemoryError 异常。

**栈上分配**

堆内对象较多需要回收时会给 GC 带来较大压力。通过 JVM 的逃逸分析确定该对象不会被外部访问，再通过标量替换将该对象分解在栈上分配内存，这样该对象所占用的内存空间就可以随栈帧出栈而销毁，就减轻了垃圾回收的压力。

#### 本地方法栈

本地方法栈与 Java 虚拟机栈类似，它们之间的区别只不过是虚拟机栈为虚拟机执行 Java 方法（也就是字节码）服务，本地方法栈为 Native 方法服务。

本地方法一般是用其它语言（C、C++ 或汇编语言等）编写的，并且被编译为基于本机硬件和操作系统的程序，对待这些方法需要特别处理。

在 HotSpot 虚拟机中和 Java 虚拟机栈合二为一。

本地方法被执行的时候，在本地方法栈也会创建一个栈帧，用于存放该本地方法的局部变量表、操作数栈、动态链接、出口信息。方法执行完毕后相应的栈帧也会出栈并释放内存空间，也会出现 StackOverFlowError 和 OutOfMemoryError 两种错误。

**线程公有**

#### 堆

所有对象都在这里分配内存，是垃圾收集的主要区域（也称 GC 堆）。

堆是 Java 虚拟机所管理的内存中最大的一块，在虚拟机启动时创建。

**分代垃圾收集**

现代的垃圾收集器基本都是采用分代收集算法，其主要的思想是针对不同类型的对象采取不同的垃圾回收算法。可以将堆分成新生代 Young Generation 和老年代 Old Generation。新生代分为 Eden、From Survivor、To Survivor。

进一步划分的目的是更好地回收内存，或者更快地分配内存。

堆里的数据都有默认值。

堆中还存放成员方法的地址，指向方法区的成员方法。

**OOM**

堆不需要物理上连续内存，并且当堆中内存不够完成对象实例的分配时，可以动态增加其内存，增加失败会抛出 OutOfMemoryError 异常。分为：

- GC Overhead Limit Exceeded：JVM 花太多时间执行垃圾回收并且只能回收很少的堆空间。

- Java heap space：在创建新的对象时，堆内存中的空间不足以存放新创建的对象。

#### 方法区

用于存放已被加载的类信息、常量、静态变量、即时编译器编译后的代码等数据，包含方法的信息。Java 虚拟机规范把方法区描述为堆的一个逻辑部分，又称非堆区域。

和堆一样不需要连续的内存，并且可以动态扩展，动态扩展失败一样会抛出 OutOfMemoryError 异常。

对这块区域进行垃圾回收的主要目标是对常量池的回收和对类的卸载，但是一般比较难实现。

**永久代和元空间**

永久代是 HotSpot 的概念。方法区是一个 JVM 规范，永久代与元空间都是其一种实现方式。

JDK1.8 之前，HotSpot 虚拟机把方法区当成永久代来进行垃圾回收。但很难确定永久代的大小，因为它受到很多因素影响，并且每次 Full GC 之后永久代的大小都会改变，所以经常会抛出 OutOfMemoryError 异常。

为了更容易管理方法区，从 JDK1.8 开始，移除永久代，并把方法区移至元空间，它位于直接内存中，而不是虚拟机内存中。

在 JDK1.8 之后，原来永久代的数据被分到了堆和元空间中。元空间存储类的元信息，静态变量和常量池等放入堆中。

如果未指定 MetaspaceSize，则元空间将根据运行时的应用程序需求动态地重新调整大小。

**为什么要将永久代替换为元空间？**

整个永久代有一个 JVM 本身设置固定大小上限，无法进行调整，而元空间使用的是直接内存，受本机可用内存的限制，不太容易得到 OOM。

而如果不指定元空间大小的话，随着更多类的创建，虚拟机会耗尽所有可用的系统内存。

**运行时常量池**

是方法区的一部分。Class 文件中的常量池（编译器生成的字面量和符号引用）会在类加载后被放入这个区域。

还允许动态生成，例如 String 类的 intern()。

JDK1.7 开始 JVM 已经将运行时常量池从方法区中移了出来，在 Java 堆中开辟了一块区域存放运行时常量池。

#### 直接内存 

不属于运行时数据区域。

在 JDK 1.4 中新引入了 NIO 类，它可以使用 Native 函数库直接分配堆外内存，然后通过 Java 堆里的 DirectByteBuffer 对象作为这块内存的引用进行操作。

这样能在一些场景中显著提高性能，因为避免了在堆内存和堆外内存来回拷贝数据。

可能导致 OutOfMemoryError 出现。



## 2.垃圾收集

垃圾收集主要是针对堆和方法区进行。

**判断一个对象是否可被回收**

**引用计数算法**

为对象添加一个引用计数器，当对象增加一个引用时计数器加 1，引用失效时计数器减 1。引用计数为 0 的对象可被回收。

在两个对象出现循环引用的情况下，此时引用计数器永远不为 0，导致无法对它们进行回收。因此 JVM 不使用引用计数算法。

#### 可达性分析算法

以 GC Roots 为起始点进行搜索，节点所走过的路径称为引用链，当一个对象到 GC Roots 没有任何引用链相连的话，则证明此对象是不可达的。可达的对象都是存活的，不可达的对象可被回收。

JVM 使用该算法来判断对象是否可被回收。

无论是通过引用计数算法判断对象的引用数量，还是通过可达性分析算法判断对象是否可达，判定对象是否可被回收都与引用有关。

**GC Roots 包含的内容**

虚拟机栈中局部变量表中引用的对象，本地方法栈中 JNI 中引用的对象，方法区中类静态属性引用的对象，方法区中的常量引用的对象。

#### **方法区的回收**

主要是对常量池的回收和对类的卸载。

永久代对象的回收率比新生代低很多，在方法区上进行回收性价比不高。

为了避免内存溢出，在大量使用反射和动态代理的场景（自定义 ClassLoader）都需要虚拟机具备类卸载功能。

**类的卸载条件**

满足了条件也不一定会被卸载。

- 该类所有的实例都已经被回收，也就是 Java 堆中不存在该类的任何实例。
- 加载该类的 ClassLoader 已经被回收。
- 该类对应的 java.lang.Class 对象没有在任何地方被引用，无法在任何地方通过反射访问该类的方法。

#### finalize()

用于关闭外部资源。

但是 try-finally 等方式可以做得更好，并且该方法运行代价很高，不确定性大，无法保证各个对象的调用顺序，因此最好不要使用。

当一个对象可被回收时，如果需要执行该对象的 finalize() 方法，那么就有可能在该方法中让对象重新被引用，从而实现自救。自救只能进行一次，如果回收的对象之前调用了 finalize() 方法自救，后面回收时不会再调用该方法。

**两次标记**

1. 可达性分析法中不可达的对象被第一次标记并且进行一次筛选，筛选的条件是此对象是否有必要执行 finalize 方法。当对象没有覆盖 finalize 方法，或 finalize 方法已经被虚拟机调用过时，虚拟机将这两种情况视为没有必要执行。

2. 被判定为需要执行的对象将会被放在一个队列中进行第二次标记，除非这个对象与引用链上的任何一个对象建立关联，否则就会被真的回收。

#### 引用类型

JDK1.2 以后。

**强引用**

被强引用关联的对象不会被回收。

使用 new 一个新对象的方式来创建强引用。

当内存空间不足，Java 虚拟机宁愿抛出 OutOfMemoryError 错误，使程序异常终止。

**软引用**

被软引用关联的对象只有在内存不够的情况下才会被回收。

使用 SoftReference 类来创建软引用。

软引用可用来实现内存敏感的高速缓存。

软引用和弱引用可以和一个引用队列 ReferenceQueue 联合使用，如果软引用所引用的对象被垃圾回收，JAVA 虚拟机就会把这个软引用加入到与之关联的引用队列中。使用软引用的情况较多，这是因为软引用可以加速 JVM 对垃圾内存的回收速度，可以维护系统的运行安全，防止内存溢出等问题的产生。        

**弱引用**

被弱引用关联的对象一定会被回收，也就是说它只能存活到下一次垃圾回收发生之前。

使用 WeakReference 类来创建弱引用。

**弱引用与软引用的区别**

只具有弱引用的对象拥有更短暂的生命周期。在垃圾回收器线程扫描它所管辖的内存区域的过程中，一旦发现了只具有弱引用的对象，不管当前内存空间足够与否，都会回收它的内存。               

**虚引用**

又称为幽灵引用或者幻影引用，一个对象是否有虚引用的存在，不会对其生存时间造成影响，也无法通过虚引用得到一个对象。为

一个对象设置虚引用的唯一目的是能在这个对象被回收时收到一个系统通知。

使用 PhantomReference 来创建虚引用。

虚引用必须和引用队列联合使用，程序可以通过判断引用队列中是否已经加入了虚引用，来了解被引用的对象是否将要被垃圾回收。

**内存泄漏**

JVM 误以为此对象还在引用中，无法回收。

- 静态集合类
- 各种连接，如数据库连接、网络连接和 IO 连接等
- 变量不合理的作用域
- 内部类持有外部类
- 改变哈希值
- 栈先增长，在收缩，那么从栈中弹出的对象将不会被当作垃圾回收
- 把对象引用放入到缓存中，很容易遗忘
- 监听器和其他回调

#### 垃圾收集算法

**标记 - 清除**

为活动对象打上标记。

**缺点**

- 标记和清除过程效率都不高。

- 会产生大量不连续的内存碎片，导致无法给大对象分配内存。

**标记 - 整理**

让所有存活的对象都向一端移动，然后直接清理掉端边界以外的内存。

**优点**

不会产生内存碎片。

**缺点**

需要移动大量对象，处理效率比较低。

**复制**

将内存划分为大小相等的两块，每次只使用其中一块，当这一块内存用完了就将还存活的对象复制到另一块上面，然后再把使用过的内存空间进行一次清理。

**缺点**

只使用了内存的一半。

**复制算法回收新生代**

并将新生代划分一块较大的 Eden 空间和两块较小的 Survivor 空间，每次使用 Eden 和其中一块 Survivor。

在回收时，将 Eden 和 Survivor 中还存活着的对象全部复制到另一块 Survivor 上，最后清理 Eden 和使用过的那一块 Survivor。然后 From 和 To 会交换他们的角色。To 区被填满之后，会将所有对象移动到老年代中。

HotSpot 虚拟机的 Eden 和 Survivor 大小比例默认为 8:1，保证了内存的利用率达到 90%。如果每次回收有多于 10% 的对象存活，一块 Survivor 不够用时，需要依赖于老年代进行空间分配担保，也就是借用老年代的空间存储放不下的对象。

**分代收集**

将堆分为新生代和老年代。

新生代使用复制算法。

老年代使用标记 - 清除或者标记 - 整理算法。

**HotSpot 为什么要分为新生代和老年代？**

在新生代中，每次收集都会有大量对象死去，所以可以选择复制算法，只需要付出少量对象的复制成本就可以完成每次垃圾收集。

而老年代的对象存活几率是比较高的，而且没有额外的空间对它进行分配担保，所以我们必须选择标记-清除或标记-整理算法进行垃圾收集。

#### 垃圾收集器

是优先级很低的线程。

**CMS 和 G1 的并行执行**

并行指的是垃圾收集器和用户程序同时执行。

**GC 停顿**

运行到安全点时会暂停所有当前运行的线程 Stop The World。

**安全点 safepoint**  

循环的末尾，方法临返回前/调用方法的 call 指令后，可能抛异常的位置。

**其他垃圾收集器**

Serial：串行，单线程，简单高效，是 Client 场景下的默认新生代收集器。

ParNew：Serial 收集器的多线程版本，是 Server 场景下默认的新生代收集器。

Parallel Scavenge：多线程，关注吞吐量以及 CPU 资源，缩短停顿时间是以牺牲吞吐量和新生代空间来换取的。

Serial Old：Serial 收集器的老年代版本，Client 场景。

Parallel Old：Parallel Scavenge 收集器的老年代版本。

**CMS**

Concurrent Mark Sweep，使用标记 - 清除算法，以获取最短回收停顿时间为目标的收集器。

**流程**

1. 初始标记：仅仅只是标记一下 GC Roots 能直接关联到的对象，速度很快，需要停顿。
2. 并发标记：进行 GC Roots Tracing 的过程，它在整个回收过程中耗时最长，不需要停顿。
3. 重新标记：为了修正并发标记期间因用户程序继续运作而导致标记产生变动的那一部分对象的标记记录，需要停顿。
4. 并发清除：不需要停顿。

在整个过程中耗时最长的并发标记和并发清除过程中，收集器线程都可以与用户线程一起工作，不需要进行停顿。

**缺点**

- 吞吐量低：低停顿时间是以牺牲吞吐量为代价的，导致 CPU 利用率不够高。CMS 收集器对 CPU 资源非常敏感。
- 无法处理浮动垃圾：浮动垃圾是并发清除阶段由于用户线程继续运行而产生的垃圾。由于浮动垃圾的存在，因此需要预留出一部分内存，意味着 CMS 收集不能像其它收集器那样等待老年代快满的时候再回收。预留的内存不够存放浮动垃圾会就会出现 Concurrent Mode Failure，这时虚拟机将临时启用 Serial Old 来替代 CMS。
- 标记 - 清除算法导致的空间碎片，往往出现老年代空间剩余，但无法找到足够大连续空间来分配当前对象，不得不提前触发一次 Full GC。

**G1**

Garbage-First，一款面向服务端应用的垃圾收集器，在多 CPU 和大内存的场景下有很好的性能。

其它收集器进行收集的范围都是整个新生代或者老年代，而 G1 可以直接对新生代和老年代一起回收。

**Region**

通过引入 Region 的概念，将原来的一整块内存空间划分成多个的小空间，使得每个小空间可以单独进行垃圾回收。这种划分方法带来了很大的灵活性，使得可预测的停顿时间模型成为可能。使新生代和老年代不再物理隔离。

通过记录每个 Region 垃圾回收时间以及回收所获得的空间（这两个值是通过过去回收的经验获得），并维护一个优先列表，每次根据允许的收集时间，优先回收价值最大的 Region。

每个 Region 都有一个 Remembered Set，用来记录该 Region 对象的引用对象所在的 Region。通过使用 Remembered Set，在做可达性分析的时候就可以避免全堆扫描。

**流程**

1. 初始标记
2. 并发标记
3. 最终标记：为了修正在并发标记期间因用户程序继续运作而导致标记产生变动的那一部分标记记录，虚拟机将这段时间对象变化记录在线程的 Remembered Set Logs 里面，最终标记阶段需要把 Remembered Set Logs 的数据合并到 Remembered Set 中。这阶段需要停顿线程，但是可并行执行。
4. 筛选回收：首先对各个 Region 中的回收价值和成本进行排序，根据用户所期望的 GC 停顿时间来制定回收计划。此阶段其实也可以做到与用户程序一起并发执行，但是因为只回收一部分 Region，时间是用户可控制的，而且停顿用户线程将大幅度提高收集效率。

**特点**

- 空间整合：整体来看是基于标记 - 整理算法实现的收集器，从局部（两个 Region 之间）上来看是基于复制算法实现的，这意味着运行期间不会产生内存空间碎片。
- 可预测的停顿：能让使用者明确指定在一个长度为 M 毫秒的时间片段内，消耗在 GC 上的时间不得超过 N 毫秒。



## 3.内存分配与回收策略

**Minor GC**

回收新生代，因为新生代对象存活时间很短，因此 Minor GC 会频繁执行，执行的速度一般也会比较快。当 Eden 空间满时，就将触发一次 Minor GC。

**Full GC**

回收老年代和新生代，老年代对象其存活时间长，因此 Full GC 很少执行，执行速度会比 Minor GC 慢很多。

#### 内存分配策略

- 对象优先在 Eden 分配：大多数情况下，对象在新生代 Eden 上分配，当 Eden 空间不够时，发起 Minor GC。
- 大对象直接进入老年代：避免在 Eden 和 Survivor 之间的大量内存复制。大对象是指需要连续内存空间的对象，最典型的大对象是那种很长的字符串以及数组。经常出现大对象会提前触发垃圾收集以获取足够的连续空间分配给大对象。
- 长期存活的对象进入老年代：为对象定义年龄计数器，对象在 Eden 出生并经过 Minor GC 依然存活，将移动到 Survivor 中，年龄就增加 1 岁，增加到一定年龄（默认为 15 岁）则移动到老年代中。
- 动态对象年龄判定：如果在 Survivor 中相同年龄所有对象大小的总和大于 Survivor 空间的一半，则年龄大于或等于该年龄的对象可以直接进入老年代，无需等到 MaxTenuringThreshold 中要求的年龄。
- 空间分配担保：在发生 Minor GC 之前，虚拟机先检查老年代最大可用的连续空间是否大于新生代所有对象总空间，如果条件成立的话，那么 Minor GC 可以确认是安全的。如果不成立的话虚拟机会查看 HandlePromotionFailure 的值是否允许担保失败，如果允许那么就会继续检查老年代最大可用的连续空间是否大于历次晋升到老年代对象的平均大小，如果大于，将尝试着进行一次 Minor GC；如果小于，或者 HandlePromotionFailure 的值不允许冒险，那么就要进行一次 Full GC。

#### Full GC 的触发条件

- 调用 System.gc()：只是建议虚拟机执行 Full GC，但是虚拟机不一定真正去执行。不建议使用这种方式，而是让虚拟机管理内存。
- 老年代空间不足：由于内存分配策略中大对象直接进入老年代、长期存活的对象进入老年代等引起。为了避免应当尽量不要创建过大的对象以及数组。除此之外，可以通过 -Xmn 虚拟机参数调大新生代的大小，让对象尽量在新生代被回收掉，不进入老年代。还可以通过 -XX:MaxTenuringThreshold 调大对象进入老年代的年龄，让对象在新生代多存活一段时间。
- 空间分配担保失败：使用复制算法的 Minor GC 需要老年代的内存空间作担保，如果担保失败会执行一次 Full GC。
- JDK 1.8 以前的永久代空间不足：当系统中要加载的类、反射的类和调用的方法较多时，永久代可能会被占满，在未配置为采用 CMS GC 的情况下会执行 Full GC。如果经过 Full GC 仍然回收不了，那么虚拟机会抛出 java.lang.OutOfMemoryError。为避免以上原因引起的 Full GC，可采用的方法为增大永久代空间或转为使用 CMS GC。
- Concurrent Mode Failure：执行 CMS GC 的过程中同时有对象要放入老年代，而此时老年代空间不足（可能是 GC 过程中浮动垃圾过多导致暂时性的空间不足），便会报 Concurrent Mode Failure 错误，并触发 Full GC。



## 4.类加载机制

加载的作用就是将 .class 文件加载到内存。

类是在运行期间第一次使用时动态加载的，而不是一次性加载所有类。因为如果一次性加载，那么会占用很多的内存。

类的生命周期：类加载，使用，卸载。

类加载包含了加载、验证、准备、解析和初始化这 5 个阶段。验证、准备、解析三个部分统称为连接。

加载阶段和连接阶段的部分内容是交叉进行的，加载阶段尚未结束，连接阶段可能就已经开始了。

#### 加载

过程完成以下三件事：

1. 通过类的完全限定名称获取定义该类的二进制字节流。一个非数组类的加载是可控性最强的，这一步我们可以自定义类加载器去控制字节流的获取方式（通过重写一个类加载器的 loadClass() 方法）。
2. 将该字节流表示的静态存储结构转换为方法区的运行时存储结构。
3. 在内存中生成一个代表该类的 Class 对象，作为方法区中该类各种数据的访问入口。

**二进制字节流获取方式**

- 从 ZIP 包读取，成为 JAR、EAR、WAR 格式的基础。
- 从网络中获取，最典型的应用是 Applet。
- 运行时计算生成，例如动态代理技术，在 java.lang.reflect.Proxy 使用 ProxyGenerator.generateProxyClass 的代理类的二进制字节流。
- 由其他文件生成，例如由 JSP 文件生成对应的 Class 类。

#### 验证

确保 Class 文件的字节流中包含的信息符合当前虚拟机的要求，并且不会危害虚拟机自身的安全。

#### 准备

类变量是被 static 修饰的变量，准备阶段为类变量分配内存并设置初始值，使用的是方法区的内存。

**实例化**

实例变量不会在这阶段分配内存，它会在对象实例化时随着对象一起被分配在堆中。

应该注意到，实例化不是类加载的一个过程，类加载发生在所有实例化操作之前，并且类加载只进行一次，实例化可以进行多次。

初始值一般为 0 值。如果类变量是常量（fianl 关键字），那么它将初始化为表达式所定义的值而不是 0。

#### 解析

将常量池的符号引用替换为直接引用的过程，也就是得到类或者字段、方法在内存中的指针或者偏移量。

**动态绑定**

其中解析过程在某些情况下可以在初始化阶段之后再开始。

#### 初始化

初始化阶段才真正开始执行类中定义的 Java 程序代码。初始化阶段是虚拟机执行类构造器 **<clinit\ >()** 方法的过程。

在准备阶段，类变量已经赋过一次系统要求的初始值，而在初始化阶段，根据程序员通过程序制定的主观计划去初始化类变量和其它资源。

**类构造器方法 <clinit\ >()** 

**<clinit\ >()** 是由编译器自动收集类中所有类变量的赋值动作和静态语句块中的语句合并产生的，编译器收集的顺序由语句在源文件中出现的顺序决定。

特别注意的是，静态语句块只能访问到定义在它之前的类变量，定义在它之后的类变量只能赋值，不能访问。                                     

父类的 **<clinit\ >()** 方法先执行，也就意味着父类中定义的静态语句块的执行要优先于子类。

**接口中的 <clinit\ >()**

接口中不可以使用静态语句块，但仍然有类变量初始化的赋值操作，因此接口与类一样都会生成 **<clinit\ >()** 方法。但接口与类不同的是，执行接口的 **<clinit\ >()** 方法不需要先执行父接口的 **<clinit\ >()** 方法。只有当父接口中定义的变量使用时，父接口才会初始化。另外，接口的实现类在初始化时也一样不会执行接口的 **<clinit\ >()** 方法。

**多线程中的 <clinit\ >()**

虚拟机会保证一个类的 **<clinit\ >()** 方法在多线程环境下被正确的加锁和同步，如果多个线程同时初始化一个类，只会有一个线程执行这个类的 **<clinit\ >()** 方法，其它线程都会阻塞等待，直到活动线程执行 **<clinit\ >()** 方法完毕。如果在一个类的 **<clinit\ >()** 方法中有耗时的操作，就可能造成多个线程阻塞，在实际过程中此种阻塞很隐蔽。

**类初始化时机**

**主动引用**

虚拟机规范严格规定了有且只有下列五种情况必须对类进行初始化（加载和连接都会随之发生）：

- 遇到 new、getstatic、putstatic、invokestatic 这四条字节码指令时，如果类没有进行过初始化，则必须先触发其初始化。最常见的生成这 4 条指令的场景是：使用 new 关键字实例化对象的时候；读取或设置一个类的静态字段（被 final 修饰、已在编译期把结果放入常量池的静态字段除外）的时候；以及调用一个类的静态方法的时候。
- 使用 java.lang.reflect 包的方法对类进行反射调用的时候，如果类没有进行初始化，则需要先触发其初始化。
- 当初始化一个类的时候，如果发现其父类还没有进行过初始化，则需要先触发其父类的初始化。
- 当虚拟机启动时，用户需要指定一个要执行的主类（包含 main() 方法的那个类），虚拟机会先初始化这个主类。
- 当使用 JDK1.7 的动态语言支持时，如果一个 java.lang.invoke.MethodHandle 实例最后的解析结果为 REF_getStatic, REF_putStatic, REF_invokeStatic 的方法句柄，并且这个方法句柄所对应的类没有进行过初始化，则需要先触发其初始化。

**被动引用**

除上述五种场景来主动引用之外，其他引用类的方式不会触发初始化。被动引用的常见例子：

- 通过子类引用父类的静态字段，不会导致子类初始化。
- 通过数组定义来引用类，不会触发此类的初始化。该过程会对数组类进行初始化，数组类是一个由虚拟机自动生成的、直接继承自 Object 的子类，其中包含了数组的属性和方法。
- 常量在编译阶段会存入调用类的常量池中，本质上并没有直接引用到定义常量的类，因此不会触发定义常量的类的初始化。

#### 类加载器

**类相等**

两个类相等，需要类本身相等，并且使用同一个类加载器进行加载。这是因为每一个类加载器都拥有一个独立的类名称空间。

相等包括类的 Class 对象的 equals() 方法、isAssignableFrom() 方法、isInstance() 方法的返回结果为 true，也包括使用 instanceof 关键字做对象所属关系判定结果为 true。

**分类**

- 启动类加载器 Bootstrap：是虚拟机自身的一部分。
- 扩展类加载器 Extension：开发者可以直接使用。
- 应用程序类加载器 Application：它负责加载用户类路径 ClassPath 上所指定的类库。
- 用户自定义类加载器

**双亲委派模型**

<img src="/Users/wangjie/Desktop/面试知识点/pic/jvm1.png" alt="jvm1" style="zoom:50%;" />

表达了类加载器之间的层次关系。一个类加载器首先将类加载请求转发到父类加载器，只有当父类加载器无法完成时才尝试自己加载。当父类加载器为 null 时，会使用启动类加载器 BootstrapClassLoader 作为父类加载器。

双亲委派模型通过组合关系而不是继承关系来实现。

**优点**

- 是使得 Java 类随着它的类加载器一起具有一种带有优先级的层次关系，从而使得基础类得到统一。

- 可以避免类的重复加载，保证了 Java 程序的稳定运行。

**破坏双亲委派模型**

受到加载范围的限制，父类加载器无法加载到需要的文件，需要委托子类实现。

**自定义类加载器**

继承自抽象类 java.lang.ClassLoader，重写 findClass()，然后在 findClass() 中调用并返回 defineClass()。

- loadClass()：实现了双亲委派模型的逻辑。先检查类是否已经加载过，如果没有则让父类加载器去加载。当父类加载器加载失败时抛出 ClassNotFoundException，此时尝试自己去加载。一般不用重写。

- findClass()：需要重写，根据类的全名在文件系统上查找 .class 文件。 

- defineClass()：把 .class 文件转换成 java.lang.Class 类的实例。

**数组的加载**

数组本身不通过类加载器创建，它是由 JVM 直接创建的。但数组的元素类型 Element Type（数组去掉所有维度）是要靠类加载器去创建，组件类型 Component Type（数组去掉一个维度）不是引用类型（如 int[]），Java 虚拟机将会把数组类标记为与引导类加载器关联。



## 5.对象的创建和访问

new 一个对象的过程：类加载，创建对象。

#### 对象的创建

类加载检查：虚拟机遇到一条 new 指令时，首先将去检查这个指令的参数是否能在常量池中定位到这个类的符号引用，并且检查这个符号引用代表的类是否已被加载过、解析和初始化过。如果没有，那必须先执行相应的类加载过程。

#### 分配内存

对象所需的内存大小在类加载完成后便可确定，为对象分配空间的任务等同于把一块确定大小的内存从 Java 堆中划分出来。
分配方式：指针碰撞，对于没有内存碎片。空闲列表，对于有内存碎片。选择那种分配方式由 Java 堆是否规整决定，而 Java 堆是否规整又由所采用的垃圾收集器是否带有压缩整理功能决定。
虚拟机采用两种方式来保证线程安全：CAS + 失败重试
TLAB：为每一个线程预先在 Eden 区分配一块儿内存，JVM 在给线程中的对象分配内存时，首先在 TLAB 分配，当对象大于 TLAB 中的剩余内存或 TLAB 的内存已用尽时，再采用上述的 CAS 进行内存分配。

#### 初始化零值

虚拟机将分配到的内存空间都初始化为零值（不包括对象头），这一步操作保证了对象的实例字段在 Java 代码中可以不赋初始值就直接使用，程序能访问到这些字段的数据类型所对应的零值。
设置对象头：对象头包含这个对象是那个类的实例、如何才能找到类的元数据信息、对象的哈希码、对象的 GC 分代年龄等信息。根据虚拟机当前运行状态的不同，如是否启用偏向锁等，对象头会有不同的设置方式。
执行 init 方法：在上面工作都完成之后，从虚拟机的视角来看，一个新的对象已经产生了，但从 Java 程序的视角来看，对象创建才刚开始，<init> 方法还没有执行，所有的字段都还为零。一般来说，执行 new 指令之后会接着执行 <init> 方法，把对象按照程序员的意愿进行初始化，这样一个真正可用的对象才算完全产生出来。

#### 对象的内存布局

在 Hotspot 虚拟机中，对象在内存中的布局可以分为 3 块区域：对象头、实例数据和对齐填充。
对象头包括两部分信息，第一部分用于存储对象自身的自身运行时数据（哈希码、GC 分代年龄、锁状态标志等等），另一部分是类型指针，即对象指向它的类元数据的指针，虚拟机通过这个指针来确定这个对象是那个类的实例。
实例数据部分是对象真正存储的有效信息，也是在程序中所定义的各种类型的字段内容。
对齐填充部分不是必然存在的，也没有什么特别的含义，仅仅起占位作用。对象的大小必须是 8 字节的整数倍。

#### 对象的访问定位

Java 程序通过栈上的 reference 数据来操作堆上的具体对象。对象的访问方式由虚拟机实现而定，目前主流的访问方式有：使用句柄和直接指针两种。
使用句柄：如果使用句柄的话，那么 Java 堆中将会划分出一块内存来作为句柄池，reference 中存储的就是对象的句柄地址，而句柄中包含了对象实例数据与类型数据各自的具体地址信息；
直接指针：如果使用直接指针访问，那么 Java 堆对象的布局中就必须考虑如何放置访问类型数据的相关信息，而 reference 中存储的直接就是对象的地址。
这两种对象访问方式各有优势。使用句柄来访问的最大好处是 reference 中存储的是稳定的句柄地址，在对象被移动时只会改变句柄中的实例数据指针，而 reference 本身不需要修改。使用直接指针访问方式最大的好处就是速度快，它节省了一次指针定位的时间开销。