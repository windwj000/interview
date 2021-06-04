## 1.概述

网络把主机连接起来，而互连网 internet 是把多种不同的网络连接起来，因此互连网是网络的网络。而互联网 Internet 是全球范围的互连网。

**互联网服务提供商 ISP**

ISP 可以从互联网管理机构获得许多 IP 地址，同时拥有通信线路以及路由器等联网设备，个人或机构向 ISP 缴纳一定的费用就可以接入互联网。

目前的互联网是一种多层次 ISP 结构。

**计网分类**

分布范围：广域网 WAN，城域网 MAN，局域网 LAN，个域网 PAN。

传输技术：广播式，点对点。

拓扑结构：星形，总线形，环形，网状形。

交换技术：电路交换，报文交换，分组交换。

计网性能指标：速率，带宽，吞吐量，时延，时延带宽积，往返时延 RTT，信道利用率。

**计算机网络体系结构**

协议，接口，服务（下层为上层），PDU=SDU+PCI。

五层协议：物理层（比特），数据链路层（帧），网络层（数据报），传输层（报文段，用户数据报），应用层。

OSI：物理层，数据链路层，网络层，传输层，会话层，表示层，应用层。

TCP/IP：网络接口层，网际层，运输层，应用层。	



## 2.物理层

通信基础

通信方式：单工，半双工，全双工。

数据传输速率：奈奎斯特定理，香农定理。

编码（转换为数字信号（离散））和调制（转换为模拟信号（连续））：曼切斯特编码，幅移键控 ASK，脉码调制 PCM，频分复用 FDM。

分组交换：数据报，虚电路。

传输介质：双绞线，同轴电缆，光纤，无线传输介质。

设备：中继器，集线器 hub。



## 3.数据链路层

组帧：比特填充法。

透明传输

差错检测：循环冗余码 CRC。

信道复用：频分复用，时分复用，统计时分复用，波分复用，码分复用。

流量控制：滑动窗口，自动重传请求 ARQ，停等协议，后退 N 帧 GBN，选择重传 SR。

可靠传输：确认和超时重传。

介质访问控制 CSMA/CD：先听后发，边听边发，冲突停发，随机重发。2τ 的争用期。截断二进制指数退避算法。

CSMA/CA

以太网：星型拓扑结构局域网，MAC 帧结构，MAC 地址用于唯一标识网络适配器（网卡）。

虚拟局域网

广域网：PPP 协议，HDLC 协议。

设备：网桥，交换机。



## 4.网络层

IP 地址是互联网上每一台计算机的唯一标识。使用 IP 协议，可以把异构的物理网络连接起来。

网络层是整个互联网的核心，因此应当让网络层尽可能简单。

TCP/IP 协议中的网络层向上只提供简单灵活的，无连接的，尽最大努力交付的数据报服务。

网络层不提供服务质量的承诺，不保证分组交付的时限，分组可能出错，丢失，重复和失序。

**IP**

IP 数据报格式：首部，分片。

IP 地址：分类，网络地址转换 NAT，子网掩码，无分类编址 CIDR。

IP 协议：地址解析协议 ARP/RARP，网际控制报文协议 ICMP，网际组管理协议 IGMP，动态主机配置协议 DHCP（应用层，基于 UDP）。

**地址解析协议 ARP**

由 IP 地址得到 MAC 硬件地址。

在通信过程中，IP 数据报的源地址和目的地址始终不变，而 MAC 地址随着链路的改变而改变。

**高速缓存**

ARP 的高速缓存可以大大减少网络上的通信量。因为这样可以使主机下次再与同样地址的主机通信时，可以直接从高速缓存中找到所需要的硬件地址而不需要再去广播方式发送 ARP 请求分组。

**网际控制报文协议 ICMP**

为了更有效地转发 IP 数据报和提高交付成功的机会。

分为差错报告报文和询问报文。

Traceroute：用来跟踪一个分组从源点到终点的路径。通过 TTL 减为 0 和主机发送终点不可达的 ICMP 报文实现。

ping：用来探测主机到主机之间是否可通信。通过向目的主机发送 ICMP Echo 请求报文，目的主机收到之后会发送 Echo 回答报文。Ping 会根据时间和成功响应的次数估算出数据包往返时间以及丢包率。

ICMP Echo 报文：类型 0 表示响应，类型 8 表示请求。

**路由算法**

距离向量算法，链路状态算法。

**路由协议**

内部网关协议 RIP（距离向量 UDP）和 OSPF（链路状态 IP），外部网关协议 BGP（路径向量 TCP）。

**其他**

IPv6：解决 IP 地址耗尽的问题。

虚拟专用网 VPN：利用公用的互联网作为本机构专用网之间的通信载体。VPN 内使用互联网的专用地址。一个 VPN 至少要有一个路由器具有合法的全球 IP 地址，这样才能和本系统的另一个 VPN 通过互联网进行通信。所有通过互联网传送的数据都需要加密。

IP 组播，移动 IP。

路由器功能：路由选择和分组转发。通过分组丢弃策略减少网络拥塞的发生。



## 5.传输层

端到端：应用进程之间的通信。	

套接字 = IP 地址 + 端口号。 

TCP 包最大 1500B，UDP 包最大 64KB。

#### UDP 和 TCP 的区别

UDP：无连接的，尽最大可能交付，没有拥塞控制，面向报文，支持一对一，一对多，多对多的交互通信， 首部开销小。只在 IP 数据报服务上增加了复用和差错检测。传输速度快，所需资源少。

TCP：面向连接的，提供可靠交付，有流量控制，拥塞控制，提供全双工通信，面向字节流，只支持一对一，首部开销大。传输速度慢，所需资源多。            

**UDP 首部**

源端口、目的端口、长度、检验和，12B 的伪首部是为了计算检验和临时添加的。8B 首部。

**TCP 首部**

源端口、目的端口、序号、确认号、首部长度、位、窗口、检验和、选项。20B 首部。	

#### 三次握手

<img src="/Users/wangjie/Desktop/面试知识点/pic/nw1.JPG" alt="nw1" style="zoom: 33%;" />

**过程**

1. 服务器处于监听状态，等待来自客户端的连接请求。

2. 客户端向服务器发送连接请求报文 SYN。服务端得出结论：客户端的发送能力、服务端的接收能力是正常的。

3. 服务器收到 SYN，如果同意建立连接，则向客户端发送连接确认报文 SYN+ACK。客户端得出结论：服务端的接收、发送能力，客户端的接收、发送能力是正常的。不过此时服务器并不能确认客户端的接收能力是否正常。

4. 客户端收到 SYN+ACK 后，还要向服务器发出确认报文 ACK。服务端得出结论：客户端的接收、发送能力正常，服务器自己的发送、接收能力也正常。

5. 服务器收到 ACK 后，连接建立。

**作用**

建立连接，确认双方的接收能力和发送能力是否正常，指定自己的初始化序列号为后面的可靠性传送做准备，交换 TCP 窗口大小信息。

**第三次握手的原因**

为了防止失效的连接请求到达服务器，让服务器错误打开连接。

1. 客户端发送的连接请求如果在网络中滞留，那么就会隔很长一段时间才能收到服务器端发回的连接确认。客户端等待一个超时重传时间之后，就会重新请求连接。

2. 数据传输完毕后，就释放了连接。但是滞留的连接请求延误到连接释放以后的某个时间才到达服务端，此时服务端误认为客户端又发出一次新的连接请求。

3. 如果不进行三次握手，那么服务器就会打开两个连接。但此时客户端忽略服务端发来的确认，也不发送数据，则服务端一致等待客户端发送数据，浪费资源。

4. 如果有第三次握手，客户端会忽略服务器之后发送的对滞留连接请求的连接确认，不进行第三次握手，因此就不会再次打开连接。

**拒绝服务攻击 DoS**

亦称洪水攻击，其目的在于使目标电脑的网络或系统资源耗尽，使服务暂时中断或停止，导致其正常用户无法访问。

分布式 DDoS。 

**SYN 洪泛攻击**

典型的 DoS 攻击，攻击客户端在短时间内伪造大量不存在的 IP 地址，向服务器不断地发送 SYN 包，服务器回复确认包，并等待客户的确认。

由于源地址是不存在的，服务器需要不断的重发直至超时，这些伪造的 SYN 包将长时间占用未连接队列，正常的 SYN 请求被丢弃，导致目标系统运行缓慢，严重者会引起网络堵塞甚至系统瘫痪。

第三次握手 ACK 报文段可以携带数据，不携带数据则不消耗序号。第一次和第二次握手不可以携带数据，前者因为会让服务器更加容易受到攻击。而对于第三次的话，此时客户端已经处于 ESTABLISHED 状态。对于客户端来说，已经建立起连接了，并且也已经知道服务器的接收和发送能力是正常的。

在 Linux/Unix 上可以使用系统自带的 netstats 命令来检测 SYN 攻击。netstat -n -p TCP | grep SYN_RECV。当你在服务器上看到大量的半连接状态时，特别是源 IP 地址是随机的，基本上可以断定这是一次 SYN 攻击。

常见的防御 SYN 攻击的方法：缩短 SYN Timeout 时间，增加最大半连接数，过滤网关防护，SYN cookies 技术。

**半连接队列**

服务器第一次收到客户端的 SYN 之后，就会处于 SYN_RCVD 状态，此时双方还没有完全建立其连接，服务器会把此种状态下请求连接放在一个队列里，我们把这种队列称之为半连接队列。

当然还有一个全连接队列，就是已经完成三次握手，建立起连接的就会放在全连接队列中。如果队列满了就有可能会出现丢包现象。

**如果第三次握手丢失了，客户端服务端会如何处理？**

服务器发送完 SYN-ACK 包，如果未收到客户确认包，服务器进行首次重传，等待一段时间仍未收到客户确认包，进行第二次重传。如果重传次数超过系统规定的最大重传次数，系统将该连接信息从半连接队列中删除。注意，每次重传等待的时间不一定相同，一般会是指数增长。

**初始序列 ISN**

当一端为建立连接而发送它的 SYN 时，它为连接选择一个初始序号。ISN 随时间而变化，因此每个连接都将具有不同的 ISN。ISN 可以看作是一个 32 比特的计数器，每 4ms 加 1。这样选择序号的目的在于防止在网络中被延迟的分组在以后又被传送，而导致某个连接的一方对它做错误的解释。

三次握手的其中一个重要功能是客户端和服务端交换 ISN，以便让对方知道接下来接收数据的时候如何按序列号组装数据。如果 ISN 是固定的，攻击者很容易猜出后续的确认号，因此 ISN 是动态生成的。

#### 四次挥手

<img src="/Users/wangjie/Desktop/面试知识点/pic/nw2.jpg" alt="nw2"  />

**过程**

1. 客户端发送连接释放报文 FIN。

2. 服务器收到 FIN 之后发出确认 ACK。此时 TCP 属于半关闭状态，服务器能向客户端发送数据但是客户端不能向服务器发送数据。

3. 当服务器不再需要连接时，发送连接释放报文 FIN+ACK。

4. 客户端收到 FIN+ACK 后发出确认 ACK。进入 TIME-WAIT 状态，等待 2MSL 后释放连接。

5. 服务器收到 ACK 后释放连接。

**四次挥手的原因**

客户端发送了 FIN 连接释放报文之后，服务器端收到了这个报文，就进入了被动关闭 CLOSE_WAIT 状态。这个状态是为了让服务器端发送还未传送完毕的数据，传送完毕之后，服务器端会发送 FIN 连接释放报文。

**TIME_WAIT**

客户端收到连接释放报文后要等 2MSL 才能关闭，两个原因：

- 确保客户端发送的最后一个 ACK 报文能够到达服务端。如果服务器没收到客户端发送来的确认报文，那么就会重新发送连接释放报文，而客户端能在 2MSL 时间内收到这个重传的连接释放报文，然后发送 ACK。
- 让本连接持续时间内所产生的所有报文都从网络中消失，使得下一个新的连接不会出现旧的连接请求报文。

**TIME_WAIT 过多**

在高并发短连接的 TCP 服务器上，当服务器处理完请求后立刻主动正常关闭连接。这个场景下会出现大量 socket 处于 TIME_WAIT 状态。如果客户端的并发量持续很高，此时部分客户端就会显示连接不上。

高并发可以让服务器在短时间范围内同时占用大量端口。

短连接表示业务处理+传输数据的时间，远远小于 TIMEWAIT 超时时间的连接。

持续的到达一定量的高并发短连接，会使服务器因端口资源不足而拒绝为一部分客户服务。同时，这些端口都是服务器临时分配，无法用 SO_REUSEADDR 选项解决这个问题。

可行而且必须存在，但是不符合原则的解决方式：

- 修改内核协议栈代码中关于这个 TIMEWAIT 的超时时间参数，重编内核，让它缩短超时时间，加快回收；
- 利用 SO_LINGER 选项的强制关闭方式，发 RST 而不是 FIN，来越过 TIMEWAIT 状态，直接进入 CLOSED 状态。

还可以使用的方法：负载均衡、打开系统的 TIMEWAIT 重用和快速回收。

**TCP 状态转移图**

TCP 协议是有状态的。

<img src="/Users/wangjie/Desktop/面试知识点/pic/nw4.png" alt="nw4" style="zoom: 67%;" />

#### 

#### TCP 可靠传输

应用数据被分割成 TCP 认为最适合发送的数据块。

TCP 的接收端会丢弃重复的数据。

**超时重传**

如果一个已经发送的报文段在超时时间内没有收到确认，那么就重传这个报文段。

**包编号**

TCP 给发送的每一个包进行编号，接收方对数据包进行排序，把有序数据传送给应用层。

**校验和**

TCP 将保持它首部和数据的检验和。这是一个端到端的检验和，目的是检测数据在传输过程中的任何变化。如果收到段的检验和有差错，TCP 将丢弃这个报文段和不确认收到此报文段。

**ARQ 协议**

每发完一个分组就停止发送，等待对方确认。在收到确认后再发下一个分组。

**UDP 实现可靠传输**

在应用层实现重传，超时重传，以及上述方法。

#### **流量控制**

为了控制发送方发送速率，保证接收方来得及接收。

**滑动窗口**

接收方发送的确认报文中的窗口字段可以用来控制发送方窗口大小，从而影响发送方的发送速率。

TCP 利用控制滑动窗口大小实现流量控制。滑动窗口是缓存的一部分。

#### **拥塞控制**

<img src="/Users/wangjie/Desktop/面试知识点/pic/nw3.JPG" alt="nw3" style="zoom: 33%;" />

当网络拥塞时，减少数据的发送。

拥塞窗口，发送窗口，接收窗口。

慢开始，拥塞避免，快重传，快恢复。

**心跳机制 KeepAlive**

连接的另一方并不知道对端的情况，为了避免资源浪费，隔一段时间给连接对端发送一个特殊数据包，如果收到对方回应的 ACK，则认为连接还是存活的，在超过一定重试次数之后还是没有收到对方的回应，则丢弃该 TCP 连接。

TCP 实际上自带的就有长连接选项，本身是也有心跳包机制，也就是 TCP 的选项：SO_KEEPALIVE。但是，TCP 协议层面的长连接灵活性不够。所以，一般情况下我们都是在应用层协议上实现自定义心跳机制的，如 Netty。

**复用与分用**

复用指发送方不同的进程都可以通过统一个运输层协议传送数据。

分用指接收方的运输层在剥去报文的首部后能把这些数据正确的交付到目的应用进程。

TCP 与 UDP 分解不同，两个具有不同源 IP 或源端口号的到达的 TCP 报文段将被重定向到两个不同的套接字。服务器主机可以支持很多并行的 TCP 套接字，每一个套接字和一个进程相联系，并由其四元组（源 IP 地址、源端口号，目的 IP 地址，目的端口号）来标识每一个套接字。

#### **TCP 粘包问题**

发送方发送的若干包数据到达接收方时粘成了一包，从接收缓冲区来看，后一包数据的头紧接着前一包数据的尾，出现粘包的原因是多方面的，可能是来自发送方，也可能是来自接收方。

UDP 则是面向消息传输的，是有保护消息边界的，接收方一次只接受一条独立的信息，所以不存在粘包问题。

**原因**

**发送方**

TCP 默认使用 Nagle 算法，为了减少网络中报文段的数量。主要做两件事：

- 只有上一个分组得到确认，才会发送下一个分组。

- 收集多个小分组，在一个确认到来时一起发送。

**接收方**

TCP 接收到数据包时，并不会马上交到应用层进行处理，而是将接收到的数据包保存在接收缓存里，然后应用程序主动从缓存读取收到的分组。

这样一来，如果TCP接收数据包到缓存的速度大于应用程序从缓存中读取数据包的速度，多个包就会被缓存，应用程序就有可能读取到多个首尾相接粘到一起的包。

**如何处理**

**发送方**

对于发送方造成的粘包问题，可以通过关闭 Nagle 算法来解决，使用 TCP_NODELAY 选项来关闭算法。

**应用层**

循环处理，应用程序从接收缓存中读取分组时，读完一条数据，就应该循环读取下一条数据，直到所有数据都被处理完成。

简单可行，不仅能解决接收方的粘包问题，还可以解决发送方的粘包问题。

**如何判断每条数据的长度？**

- 格式化数据：每条数据有固定的格式，有开始符和结束符。这种方法简单易行，但是选择开始符和结束符时一定要确保每条数据的内部不包含开始符和结束符。

- 发送长度：发送每条数据时，将数据的长度一并发送，应用层在处理时可以根据长度来判断每个分组的开始和结束位置。



## 6.应用层

主机之间的通信方式：客户-服务器 C/S，对等 P2P。

域名系统 DNS（UDP 端口 53，长度超过 512 字节时使用 TCP）：递归与迭代域名解析查询。DNS 客户端一般递归，DNS 服务器之间一般迭代。

文件传输协议 FTP（TCP 端口 20/21）：控制连接和数据连接。又叫主动模式和被动模式。

电子邮件协议（TCP 端口 25 110）：发送 SMTP，接收 POP3，MIME。

超文本传输协议 HTTP（TCP 端口 80）：Wireshark 捕获 HTTP 请求报文。

远程登录协议 TELNET（TCP 端口 23）



## 7.浏览器输入 URL 发生了什么？

**DHCP 获取 IP 地址**

**ARP 解析 MAC 地址**

#### DNS 解析

作为可以将域名和IP地址相互映射的一个分布式数据库。

次级域名.顶级域名.根域名

这个 . 对应的就是根域名服务器，默认情况下所有的网址的最后一位都是 .，既然是默认情况下，为了方便用户，通常都会省略，浏览器在请求 DNS 的时候会自动加上，所有网址真正的解析过程为: . -> com. -> google.com. -> www.google.com.。

**DNS 缓存查找**

1. chrome 浏览器中输入 chrome://net-internals/#dns，你可以看到 chrome 浏览器的 DNS 缓存。

2. 操作系统缓存主要存在 /etc/hosts 中。

3. 互联网服务提供商 ISP 提供的本地域名服务器 LDNS。

4. 最后本地域名服务器得到 IP 地址并把它缓存到本地，供下次查询使用。

**DNS 负载均衡**

DNS 返回的 IP 地址每次都不一样，DNS 可以返回一个合适的机器的 IP 给用户，例如可以根据每台机器的负载量，该机器离用户地理位置的距离等等，这种过程就是 DNS 负载均衡，又叫做 DNS 重定向。大家耳熟能详的 CDN 就是利用 DNS 的重定向技术。

**DNS 在两种情况下会使用 TCP 进行传输**

- 如果返回的响应超过的 512 字节（UDP 最大只支持 512 字节的数据）。
- 区域传送（区域传送是主域名服务器向辅助域名服务器传送变化的那部分数据）。

**TCP 连接**

**发送 HTTP 请求**

**服务器处理请求并返回 HTTP 响应**

**浏览器解析渲染页面**