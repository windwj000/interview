## 1.海量数据

处理思路：计算容量 + 拆分 + 整合。 

**计算容量**

1KB=2^10B=10^3B，1 亿个整数占 400MB。

#### 拆分

可以将海量数据拆分到多台机器上和拆分到多个文件上。

如果数据量很大，无法放在一台机器上，就将数据拆分到多台机器上。

如果在程序运行时无法直接加载一个大文件到内存中，就将大文件拆分成小文件，分别对每个小文件进行求解。

这种方式可以让多台机器一起合作，从而使得问题的求解更加快速。但是也会导致系统更加复杂，而且需要考虑系统故障等问题。

**拆分策略**

**按出现的顺序拆分**

当有新数据到达时，先放进当前机器，填满之后再将数据放到新增的机器上。

优点：充分利用系统的资源，因为每台机器都会尽可能被填满。

缺点：需要一个查找表来保存数据到机器的映射，查找表可能会非常复杂并且非常大。

**按散列值拆分**

选取数据的主键 key，然后通过哈希取模 hash(key)%N 得到该数据应该拆分到的机器编号，其中 N 是机器的数量。

优点：不需要使用查找表。

缺点：可能会导致一台机器存储的数据过多，甚至超出它的最大容量。

**按数据的实际含义拆分**

例如一个社交网站系统，来自同一个地区的用户更有可能成为朋友，让同一个地区的用户尽可能存储在同一个机器上。

优点：在查找一个用户的好友信息时，就可以避免到多台机器上查找，从而降低延迟。

缺点：同样是需要使用查找表。

#### 判重

要求判断一个数据是否已经存在。

这个数据很有可能是字符串，例如 URL。

**HashSet**

最直观，时间复杂度 O(1)。

考虑到数据是海量的，那么就需要使用拆分的方式将数据拆分到多台机器上，分别在每台机器上使用 HashSet 存储。我们需要使得相同的数据拆分到相同的机器上，可以使用哈希取模的拆分方式进行实现。

**BitSet**

通过构建一定大小的比特数组，并且让每个整数都映射到这个比特数组上，就可以很容易地知道某个整数是否已经存在。

要求海量数据是整数并且范围不大。

因为比特数组比整型数组小的多，所以通常情况下单机就能处理海量数据。

还可以解决一个整数出现次数的问题。例如使用两个比特数组就可以存储 0~3 的信息。其实判重问题也可以简单看成一个数据出现的次数是否为 1，因此一个比特数组就够了。

**布隆过滤器**

空间开销极小，但会有一定的误判概率。

解除了 BitSet 要求数据的范围不大的限制。

它主要用在网页黑名单系统、垃圾邮件过滤系统、爬虫的网址判重系统。用于海量数据去重或者验证数据合法性。

先经过 k 个哈希函数得到 k 个位置，并将 BitSet 中对应位置设置为 1。查找时所有 k 位置上都为 1，那么表示这个数据存在。

布隆过滤器说某个元素不在，那么这个元素一定不在。

**误判**

由于哈希函数的特点，两个不同的数通过哈希函数得到的值可能相同。如果两个数通过 k 个哈希函数得到的值都相同，那么使用布隆过滤器会将这两个数判为相同。

理论情况下添加到集合中的元素越多，误判的可能性就越大。

令 k 和 m（BitSet 的大小）都大一些会使得误判率降低，但是这会带来更高的时间和空间开销。

可以使用白名单的方式进行补救。

**问题**

- 不支持删除：随着时间的流逝，这个过滤器的数组中为 1 的位置越来越多，带来的结果就是误判率的提升。从而必须得进行重建。Counting Bloom Filter 可以将一比特的空间扩大成一个计数器，用多占用几倍的存储空间的代价，给 Bloom Filter 增加了删除操作。

- 查询性能不高：真实场景中过滤器中的数组长度是非常长的，经过多个不同 Hash 函数后，得到的数组下标在内存中的跨度可能会非常的大。这种不连续，就会导致 CPU 缓存行命中率低。

**实现**

Guava 提供的布隆过滤器的实现还是很不错的，但是它有一个重大的缺陷就是只能单机使用（另外，容量扩展也不容易），而现在互联网一般都是分布式的场景。为了解决这个问题，我们就需要用到 Redis 中的布隆过滤器了。

Redis v4.0 之后有了模块 Module 功能，Redis Modules 让 Redis 可以使用外部模块扩展其功能。官网推荐了一个 RedisBloom 作为 Redis 布隆过滤器的 Module。

**布谷鸟过滤器**

支持删除，在空间或性能上并不需要更高的开销。

使用的异或运算，所以这两个位置具有对偶性。

但强制数组的长度必须是 2 的指数倍。

指纹

Cuckoo hashing

<img src="/Users/wangjie/Desktop/面试知识点/pic/advanced1.png" alt="advanced1" style="zoom: 50%;" />

出现循环踢出导致放不进 x 的问题，说明布谷鸟 hash 已经到了极限情况，应该进行扩容，或者 hash 函数的优化。

**字典树 Trie** 

又叫前缀树、单词查找树。是多叉查找树，键不是直接保存在节点中，而是由节点在树中的位置决定。

适用于字符串数据，查找效率高，空间开销大。

#### 排序

**外部排序**

拆分后的数据装入内存并排序，合并时用多路归并方法。

小顶堆解决合并节点仍然无法将所有数据读入内存的问题，并设置缓存应对频繁地读写磁盘。

**BitMap**

某个数据存在时就将对应的比特数组位置设置为 1，最后从头遍历比特数组就能得到一个排序的整数序列。

适用于待排序的数据是整数，或者是其它范围比较小的数据。

**计数排序**

只能处理数据不重复的情况，如果数据重复，就要将比特数组转换成整数数组用于计数，称为计数排序。

**Trie**

针对字符串。按字典序先序遍历 Trie 树就能得到已排序的数据。

为了处理数据重复问题，可以使用 Trie 树的节点存储计数信息。

#### TopK 问题

第 K 大问题：先找到 Kth Element 之后，再遍历一遍，大于等于 Kth Element 的数都是 TopK Elements。

**快速选择**

时间复杂度 O(N)，空间复杂度 O(1)。允许修改数组元素。

**堆排序**

最大的 TopK 用小顶堆，时间复杂度 O(NlogK)，空间复杂度 O(K)。

**Heavy Hitters 问题**

找出最频繁出现的 K 个数。

HashMap 统计频率->TopK 问题

**Count-Min Sketch**

类似于布隆过滤器，也具有一定的误差。

能够在单机环境下解决海量数据的频率统计问题。

**Trie**

用于解决词频统计问题。

节点保存出现的频率。

很好地适应海量数据场景，因为 Trie 树通常不高，需要的空间不会很大。

#### **MapReduce**

用来对海量数据进行离线分析，通过将计算任务分配给集群的多台机器，使得这些计算能够并行地执行。

MapReduce 的原理就是一个归并排序。分为映射 Map（对每个目标应用同一操作）和归纳 Reduce（整合部分结果）两个阶段。

Shuffle：排序并将拥有相同键的数据整合。位于 Mapper 和 Reducer 之间的阶段。



## 2.系统设计

#### 限流算法

如果一段时间内请求的数量过大，就会给服务器造成很大压力，可能导致服务器无法提供其它服务。

**计数器算法**

通过一个计数器 counter 来统计一段时间内请求的数量，并且在指定的时间之后重置计数器。

实现简单，但是有临界问题，在重置计数器的前后一小段时间内请求突增。无法保证限流速率。

**滑动窗口算法**

是计数器算法的一种改进，将原来的一个时间窗口划分成多个时间窗口，并且不断向右滑动该窗口。

在临界位置的突发请求都会被算到时间窗口内，因此可以解决计数器算法的临界问题。  

当滑动窗口的格子划分的越多，滑动窗口的滚动就越平滑，限流的统计就会越精确。

**漏桶算法**

请求需要先放入缓存（或队列）中，当缓存满了时，请求会被丢弃。

能够以恒定速率处理请求。

**令牌桶算法**

和漏桶算法的区别在于它是以恒定速率添加令牌，当一个请求到来时，先从令牌桶取出一个令牌，如果能取到令牌那么就可以处理该请求。

令牌桶的大小有限，超过一定的令牌之后再添加进来的令牌会被丢弃。

令牌桶算法允许突发请求，因为令牌桶存放了很多令牌，那么大量的突发请求会被执行。但是它不会出现临界问题，在令牌用完之后，令牌是以一个恒定的速率添加到令牌桶中的，因此不能再次发送大量突发请求。

**基于 redis lua 的分布式限流**

redis 的性能很好，处理能力强，且容灾能力也不错。
一个 lua 脚本在 redis 中就是一个原子性操作，可以保证数据的正确性。
由于要做限流，那么肯定有 key 来记录限流的累加数，此 key 可以随着时间进行任意变动。而且 key 需要设置过期参数，防止无效数据过多而导致 redis 性能问题。
优点：集群整体流量控制，防止雪崩效应。
也可以用 zk 来做。zk 强一致性，redis 性能。

#### 扫二维码登录过程

传统的登录方式需要用户在浏览器中输入账号密码，完成输入之后点击登录按钮将这些数据发送到服务器上，服务器对这些数据进行验证并返回特定的状态码和 Cookie 等信息给浏览器。

扫二维码登录方式不需要用户输入账号密码，这些信息保存在手机 APP 中，并由 APP 发送到服务器上。

1. 登录二维码包含了服务器的 URL 地址，也包含了 uuid 参数。当用户使用手机 APP 扫描二维码登录之后，发送用户名、密码、uuid 等信息给服务器，服务器验证之后就将 uuid 和该账户关联并保存到 Session 中。

2. 浏览器需要不断地向服务器发送 AJAX 请求，该请求包含了 uuid 参数，当查询到服务器已经存在 uuid 和账户的关联信息之后，就可以知道是某个账户扫描了该二维码登录，服务器返回 200 成功状态码、Cookie 和账户信息等数据，浏览器接收到这些数据之后就可以完成登录操作。应该注意到，为了使的浏览器能不断发送 AJAX 请求，建立的 HTTP 连接需要是长连接。

#### 短网址生成系统 TinyURL

过长的网址不利于传播，TinyURL 可以将一个网址变短。在浏览器中输入短网址之后，TinyURL 会将该短网址转换成原始网址并进行重定向。

生成短网址格式：https://tinyurl.com/ID。https://tinyurl.com/ 是域名，所有的短网址都相同，而不同的短网址 ID 部分不同。分布式 ID 生成器生成 ID。

**映射**

为了让原始网址和短网址能一一对应，就需要存储双向映射。

**存储**

映射关系可以表示为键值对，可以使用 LevelDB 这种基于磁盘的键值存储系统来存储海量键值对数据，而使用 Redis 作为缓存。

**重定向**

TinyURL 会将输入的短网址转换为原始网址并进行重定向，HTTP 主要有两种重定向方式：永久重定向 301 和临时重定向 302。如果使用 301 的话，搜索引擎会直接展示原始网址，那么 TinyURL 就无法收集用户的 User Agent 等信息。这些信息可以用来做一些大数据分析，从而为 TinyURL 带来收益，所以需要使用 302 重定向。



## 3.智力题

#### 赛马次数

有 25 匹马和 5 条赛道，赛马过程无法计时，只能知道相对快慢。问最少需要几场赛马可以知道前 3 名。

答：7 场。

1. 先把 25 匹马分成 5 组，进行 5 场赛马，得到每组的排名。

2. 再将每组的第 1 名选出，进行 1 场赛马，按照这场的排名将 5 组先后标为 A、B、C、D、E。可以知道，A 组的第 1 名就是所有 25 匹马的第 1 名。而第 2、3 名只可能在 A 组的 2、3 名，B 组的第 1、2 名，和 C 组的第 1 名，总共 5 匹马。
3. 让这 5 匹马再进行 1 场赛马，前两名就是第 2、3 名。

#### 用绳子计时 15 分钟

给定两条绳子，每条绳子烧完正好一个小时，并且绳子是不均匀的。如何准确测量 15 分钟。

1. 点燃第一条绳子 R1 两头的同时，点燃第二条绳子 R2 的一头；
2. 当 R1 烧完，正好过去 30 分钟，而 R2 还可以再烧 30 分钟；
3. 点燃 R2 的另一头，15 分钟后，R2 将全部烧完。

#### 九球称重

有 9 个球，其中 8 个球质量相同，有 1 个球比较重。要求用 2 次天平，找出比较重的那个球。

1. 将这些球均分成 3 个一组共 3 组，选出 2 组称重，如果 1 组比较重，那么重球在比较重的那 1 组；如果重量相等，那么重球在另外 1 组。
2. 对比较重的那 1 组的 3 个球再分成 3 组，重复上面的步骤。

#### 药丸称重

有 20 瓶药丸，其中 19 瓶药丸质量相同为 1 克，剩下一瓶药丸质量为 1.1 克。瓶子中有无数个药丸。要求用一次天平找出药丸质量 1.1 克的药瓶。

1. 从第 i 瓶药丸中取出 i 个药丸，然后一起称重。可以知道，如果第 i 瓶药丸重 1.1 克/粒，那么称重结果就会比正常情况下重 0.1 * i 克。

#### 得到 4 升的水

有两个杯子，容量分别为 5 升和 3 升，水的供应不断。问怎么用这两个杯子得到 4 升的水。

1. 可以理解为用若干个 5 和 3 做减法得到 4。
2. 5-3=2，3-2=1，5-1=4。

#### 扔鸡蛋

一栋楼有 100 层，在第 N 层或者更高扔鸡蛋会破，而第 N 层往下则不会。给 2 个鸡蛋，求 N，要求最差的情况下扔鸡蛋的次数最少。

1. 可以将楼层划分成多个区间，第一个鸡蛋 E1 用来确定 N 属于哪个区间，第二个鸡蛋 E2 按顺序遍历该区间找到 N。那么问题就转换为怎么划分区间满足最坏情况下扔鸡蛋次数最少。
2. 为了使最坏情况下 E1 和 E2 总共遍历的次数比较少，那么后面的区间大小要比前面的区间更小。最坏情况下 E1 遍历到最后一个区间，E2 可以遍历的最少。
3. X (X + 1) / 2 = 100 ，即 X = 14。X 为第一个区间大小。



## 4.数学与逻辑

#### 抢红包算法

**二倍均值法**

每次分配的红包为 [0, 2*M/N] 之间的某个随机数（人数为 N，钱数为 M），那么分配的红包的均值为 M/N。

该算法可以保证每次分配的红包均值都为 M/N，但是并不能保证每个红包的均值都一样。

**线段切割法**

在一条线段上找 N-1 个随机点，就可以将该线段随机且公平地切割成 N 段。

#### **洗牌算法 Fisher–Yates shuffle**

用于随机打乱一组数，并且时间复杂度为 O(N)。

算法的基本思想：每次从一组数中随机选出一个数，然后与最后一个数交换位置，并且不再考虑最后一个数。

```java
public static void shuffle(int[] nums) {
    Random random = new Random();
    for (int i = nums.length - 1; i >= 0; i--) {
        int j = random.nextInt(i + 1); // [0,i]
        swap(nums, i, j);
    }
}

private static void swap(int[] nums, int i, int j) {
    int temp = nums[i];
    nums[i] = nums[j];
    nums[j] = temp;
}
```

#### 由 Rand5 实现 Rand7

类比数值的进制转换，两位 Rand5 可以产生[0,24)，截取 [0,21)，再对 7 求余就可以解决。

#### 蓄水池采样

给定一个无限的数据流，要求随机取出 k 个数。也就是说当数据流有 N 个数据时，不论 N 为多少，每个数被取出的概率都为 k/N。

先取出前 k 个数。从第 k+1 开始，以 k/i 的概率取出这个数，并随机替换掉之前已经取出的 k 个数中的一个。

#### Twitter-Snowflake 算法

为了满足 Twitter 每秒上万条消息的请求，每条消息都必须分配一条唯一的 id，这些 id 还需要一些大致的顺序（方便客户端排序），并且在分布式系统中不同机器产生的 id 必须不同。

核心：把时间戳，工作机器 id，序列号组合在一起。默认 41b 时间戳、10b 工作机器 id、12b 序列号。