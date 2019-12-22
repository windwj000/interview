<!-- GFM-TOC -->
[1.简介](#1.简介)
[2.作用](#2.作用)
[3.与虚拟机的比较](#3.与虚拟机的比较)
[4.Docker 的优势](#4.Docker 的优势)
[5.使用场景](#5.使用场景)
[6.镜像与容器、仓库](#6.镜像与容器、仓库)
[7.原理](#7.原理)
[8.Docker 引擎与架构](8.Docker 引擎与架构)
<!-- GFM-TOC -->

# 1.简介
Docker 是一个开放源代码软件项目，让应用程序部署在软件货柜下的工作可以自动化进行，借此在 Linux 操作系统上，提供一个额外的软件抽象层，以及操作系统层虚拟化的自动管理机制。

Docker 项目的目标是实现轻量级的操作系统虚拟化解决方案。Docker 的基础是 Linux 容器 LXC 等技术。在 LXC 的基础上 Docker 进行了进一步的封装，让用户不需要去关心容器的管理，使得操作更为简便。用户操作 Docker 的容器就像操作一个快速轻量级的虚拟机一样简单。

Docker 容器是在操作系统层面上实现虚拟化，直接复用本地主机的操作系统，而传统方式虚拟机则是在硬件层面实现。



# 2.作用
由于不同的机器有不同的操作系统，以及不同的库和组件，在将一个应用部署到多台机器上需要进行大量的环境配置操作。

Docker 主要解决环境配置问题，它是一种虚拟化技术，对进程进行隔离，被隔离的进程独立于宿主操作系统和其它隔离的进程。

使用 Docker 可以不修改应用程序代码，不需要开发人员学习特定环境下的技术，就能够将现有的应用程序部署在其它机器上。

把生产环境和开发环境分开。



## 1.更快速的交付和部署

Docker 在整个开发周期都可以完美的辅助你实现快速交付。Docker 允许开发者在装有应用和服务本地容器做开发。可以直接集成到可持续开发流程中。

## 2.高效的部署和扩容

Docker 容器几乎可以在任意的平台上运行，包括物理机、虚拟机、公有云、私有云、个人电脑、服务器等。这种兼容性可以让用户把一个应用程序从一个平台直接迁移到另外一个。Docker 的兼容性和轻量特性可以很轻松的实现负载的动态管理。你可以快速扩容或方便的下线的你的应用和服务，这种速度趋近实时。

## 3.更高的资源利用率

Docker 对系统资源的利用率很高，一台主机上可以同时运行数千个 Docker 容器。容器除了运行其中应用外，基本不消耗额外的系统资源，使得应用的性能很高，同时系统的开销尽量小。

## 4.更简单的管理

使用 Docker，只需要小小的修改，就可以替代以往大量的更新工作。所有的修改都以增量的方式被分发和更新，从而实现自动化并且高效的管理。



# 3.与虚拟机的比较
虚拟机也是一种虚拟化技术，它与 Docker 最大的区别在于它是通过模拟硬件，并在硬件上安装操作系统来实现。能将一台服务器变成多台服务器。

容器与虚拟机两者是可以共存的。



## 1.启动速度

启动虚拟机需要先启动虚拟机的操作系统，再启动应用，这个过程非常慢；而启动 Docker 相当于启动宿主操作系统上的一个进程。虚拟机更擅长于彻底隔离整个运行环境，容器的隔离级别会稍低一些。

## 2.占用资源

虚拟机是一个完整的操作系统，需要占用大量的磁盘、内存和 CPU 资源，一台机器只能开启几十个的虚拟机；而 Docker 只是一个进程，只需要将应用以及相关的组件打包，在运行时占用很少的资源，一台机器可以开启成千上万个 Docker。



# 4.Docker 的优势
启动速度快以及占用资源少。



## 1.更容易迁移

提供一致性的运行环境。已经打包好的应用可以在不同的机器上进行迁移，而不用担心环境变化导致无法运行。

## 2.更容易维护

使用分层技术和镜像，使得应用可以更容易复用重复的部分。复用程度越高，维护工作也越容易。

## 3.更容易扩展

可以使用基础镜像进一步扩展得到新的镜像，并且官方和开源社区提供了大量的镜像，通过扩展这些镜像可以非常容易得到我们想要的镜像。



# 5.使用场景
## 1.持续集成

频繁地将代码集成到主干上，这样能够更快地发现错误。Docker 具有轻量级以及隔离性的特点，在将代码集成到一个 Docker 中不会对其它 Docker 产生影响。

## 2.提供可伸缩的云服务

根据应用的负载情况，可以很容易地增加或者减少 Docker。

## 3.搭建微服务架构

Docker 轻量级的特点使得它很适合用于部署、维护、组合微服务。



# 6.镜像与容器、仓库
镜像是一种静态的结构，可以看成面向对象里面的类，而容器是镜像的一个实例。

镜像包含着容器运行时所需要的代码以及其它组件，它是一种分层结构，每一层都是只读的 read-only layers。构建镜像时，会一层一层构建，前一层是后一层的基础。镜像的这种分层存储结构很适合镜像的复用以及定制。

构建容器时，通过在镜像的基础上添加一个可写层 writable layer，用来保存着容器运行过程中的修改。

同一个镜像可以对应多个容器。



## 镜像

一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。 镜像不包含任何动态数据，其内容在构建之后也不会被改变。

Docker 设计时，就充分利用统一文件系统 Union FS 的技术，将其设计为分层存储的架构。镜像实际是由多层文件系统联合组成。

镜像构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。因此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。            

分层存储的特征还使得镜像的复用、定制变的更为容易。甚至可以用之前构建好的镜像作为基础层，然后进一步添加新的层，以定制自己所需的内容，构建新的镜像。

## 容器

镜像运行时的实体，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等 。容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的命名空间。前面讲过镜像使用的是分层存储，容器也是如此。

容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。因此，任何保存于容器存储层的信息都会随容器删除而丢失。

容器不应该向其存储层内写入任何数据，容器存储层要保持无状态化。所有的文件写入操作，都应该使用数据卷 Volume、或者绑定宿主目录，在这些位置的读写会跳过容器存储层，直接对宿主 (或网络存储) 发生读写，其性能和稳定性更高。数据卷的生存周期独立于容器，容器消亡，数据卷不会消亡。因此，使用数据卷后，容器可以随意删除、重新 run ，数据却不会丢失。

## 仓库

集中存放镜像文件的地方，一个 Docker Registry 中可以包含多个仓库 Repository，每个仓库可以包含多个标签 Tag，每个标签对应一个镜像。通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本 。

仓库分为公开和私有。最大的公开仓库是 Docker Hub。



# 7.原理
Linux 命名空间、控制组和 UnionFS 三大技术支撑了目前 Docker 的实现

命名空间（namespaces）是 Linux 为我们提供的用于分离进程树、网络接口、挂载点以及进程间通信等资源的方法。
我们通过 Linux 的命名空间为新创建的进程隔离了文件系统、网络并与宿主机器之间的进程相互隔离，但是命名空间并不能够为我们提供物理资源上的隔离。

CGroups 能够隔离宿主机器上的物理资源，例如 CPU、内存、磁盘 I/O 和网络带宽。

Linux 的命名空间和控制组分别解决了不同资源隔离的问题，前者解决了进程、网络以及文件系统的隔离，后者实现了 CPU、内存等资源的隔离。

UnionFS 其实是一种为 Linux 操作系统设计的用于把多个文件系统『联合』到同一个挂载点的文件系统服务，解决镜像问题。
AUFS 是一个能透明覆盖一或多个现有文件系统的层状文件系统。支持将不同目录挂载到同一个虚拟文件系统下，可以把不同的目录联合在一起，组成一个单一的目录。这种是一种虚拟的文件系统，文件系统不用格式化，直接挂载即可。

LXC 是 Linux containers 的简称，是一种基于容器的操作系统层级的虚拟化技术。借助于 namespace 的隔离机制和 cgroup 限额功能，LXC 提供了一套统一的 API 和工具来建立和管理 container。
标准统一的打包部署运行方案。



# 8.Docker 引擎与架构

Docker 引擎是一个 c/s 结构：

![docker1](https://github.com/jiebcoder/interview/blob/master/pics/docker1.png)

server 是一个常驻进程。

REST API 实现了 client 和 server 间的交互协议。

CLI 实现容器和镜像的管理，为用户提供统一的操作界面。



C/S 架构：Client 通过接口与 Server 进程通信实现容器的构建，运行和发布。client 和 server 可以运行在同一台集群，也可以通过跨主机实现远程通信。

![docker2](https://github.com/jiebcoder/interview/blob/master/pics/docker2.png)
