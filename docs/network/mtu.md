## 什么是 MTU？

在网络中，最大传输单元（MTU）指通过联网设备可以接收的最大数据包的值。可将 MTU 想象为高速公路地下通道或隧道的高度限制：超过高度限制的汽车和卡车无法通过，就像超过网络 MTU 的数据包无法通过该网络一样。

不过，与汽车和卡车不同的是，超过 MTU 的数据包可被分解成较小的碎片，从而能通过网络。这个过程称为分片。分片的数据包在到达目的地后便会重新组装。

MTU 以字节数为单位，一个“字节”等于 8 位信息，即 8 个一和零。1,500 字节是最大 MTU 大小。

## 什么是数据包？

通过互联网发送的所有数据都分解为较小的块，称为“数据包”。例如，当网页从 Web 服务器发送到用户的笔记本电脑时，构成该网页的数据以一系列数据包的形式在互联网上传递。然后，笔记本电脑将数据包重新组装成原始的整个网页。

数据包有两个主要部分：*标头*和*有效负载*。标头包含有关数据包的源地址和目的地地址的信息，而有效负载是数据包的实际内容。可将标头看作附在包裹上的运输标签，有效负载就是包裹的内容。（与包裹不同，互联网上的数据包具有由不同网络协议附加的多个标头。）

MTU 几乎总是在提及[第 3 层](https://www.cloudflare.com/learning/ddos/layer-3-ddos-attacks/)* 数据包或使用[互联网协议（IP）](https://www.cloudflare.com/learning/ddos/glossary/internet-protocol/)的数据包时使用。MTU 测量数据包的总大小，包括所有标头和有效负载。这包括 IP 标头和 [TCP（传输控制协议）](https://www.cloudflare.com/learning/ddos/glossary/tcp-ip/)标头，它们通常最多增加 40 字节的长度。

** [OSI 模型](https://www.cloudflare.com/learning/ddos/glossary/open-systems-interconnection-model-osi/)将使互联网成为可能的功能划分为 7 层；第 3 层是[网络层](https://www.cloudflare.com/learning/network-layer/what-is-the-network-layer/)，在其中进行[路由](https://www.cloudflare.com/learning/network-layer/what-is-routing/)。*

## 数据包在何时会分片？

当两个计算设备打开连接并开始交换数据包时，这些数据包会在多个网络中路由。需要考虑的不仅仅是通信两端设备的 MTU，还有两者中间所有[路由器](https://www.cloudflare.com/learning/network-layer/what-is-a-router/)、[交换机](https://www.cloudflare.com/learning/network-layer/what-is-a-network-switch/)和服务器的 MTU。超过网络路径中任一点之 MTU 的数据包都会被分片。

假设服务器 A 和计算机 A 彼此连接，但是它们相互发送的数据包必须沿途经过路由器 B 和路由器 C。服务器 A、计算机 A 和路由器 B 的 MTU 均为 1,500 字节。不过，路由器 C 的 MTU 为 1,400 字节。如果服务器 A 和计算机 A 不知道路由器 C 的 MTU 并且发送了 1500 字节的数据包，则所有数据包会在传输过程中被路由器 B 分片。

![最大传输单位——数据包被分片以适合 1,400 字节的 MTU。](https://www.cloudflare.com/resources/images/slt3lc6tev37/4scqAPBzaxHsj3SF9ikdFC/baf0be0ff26dc7f942ece5a834196856/mtu_fragmentation_diagram.png)

分片会给网络通信增加少许[延迟](https://www.cloudflare.com/learning/performance/glossary/what-is-latency/)和低效率，因此应当要尽可能避免。（过时的网络设备可能容易遭受利用分片的[拒绝服务](https://www.cloudflare.com/learning/ddos/layer-3-ddos-attacks/)攻击，例如[死亡之 Ping](https://www.cloudflare.com/learning/ddos/ping-of-death-ddos-attack/) 攻击。）

## 分片如何工作？

所有网络路由器都会根据接收数据包的下一路由器的 MTU，检查它们收到的每个 IP 数据包的大小。如果数据包超出下一路由器的 MTU，则第一个路由器会将有效负载分成两个或多个数据包，每个数据包都有自己的标头。

每一个新数据包具有从原始数据包复制的标头（从而使数据包都具有原始的来源和目的地 [IP 地址](https://www.cloudflare.com/learning/dns/glossary/what-is-my-ip-address/)等），以及一些重要的变化。路由器编辑 IP 标头中的某些字段，以指示数据包已被分片并且需要重新组装，共有多少个数据包，以及以什么样的顺序发送。

打个比方，一家运输公司正在处理的一个包裹超过了其某个设施的重量限制。运输公司没有拒绝运送这个包裹，而是将包裹内容物分成三个较小的包裹。它也复制了每个包裹的运输标签，并添加一条备注，指出每个包裹是必须一起到达的系列包裹的一部分。第一包裹是 3 之 1，第二包裹是 3 之 2，依此类推。（运输公司这样做会侵犯隐私，所以现实世界中应该不会发生这样的情况。）

## 何时无法分片？

在某些情况下，数据包无法分片；因此，如果数据包超出网络路径上任何路由器或设备的 MTU，那么不会传输这个数据包：

1. [IPv6](https://www.cloudflare.com/ipv6/) 中不允许分片。IPv6 是互联网协议的最新版本，但 IPv4 仍然广泛采用。支持 IPv6 的路由器将丢弃任何超出 MTU 的 IPv6 数据包，因为它们无法分片。
2. 当数据包的 IP 标头中激活了“不分片”标志时，也不会分片。

## 什么是 IP 标头中的“不分片”标志？

可以将 IP 标头比作消费者将包裹运送给他人时填写的表单。表单指明了源地址、目的地地址、包裹应送达的时间，以及供快递人员查阅的特殊说明。

“不分片”标志是面向路由器的特殊说明，可在 IP 标头的“表单”中选择的一个选项。设置了这个标志后，所附的数据包无法分片。

任何收到该数据包的路由器都会分析标头并检查“不分片”标志。如果标志已开启并且数据包超过 MTU，则路由器将丢弃数据包而不是对其进行分片。

除了丢弃数据包之外，路由器还会发回一条 [ICMP](https://www.cloudflare.com/learning/ddos/glossary/internet-control-message-protocol-icmp/) 消息到数据包的源头。ICMP 消息是一个很小的数据包，用于发送状态更新。在这种情况下，它本质上说：“此路由器或设备无法传递这些数据包，因为它们太大且无法分片。”

## 什么是路径 MTU 发现？

路径 MTU 发现或 PMTUD 是发现网络路径上所有设备、路由器和交换机的 MTU 的过程。如果上例中的计算机 A 和服务器 A 使用 PMTUD，它们将识别路由器 B 的 MTU 要求，并相应地调整其数据包大小以避免分片。

根据所连接的设备使用的是 IPv4 还是 IPv6，PMTU 的工作方式略有不同：

**IPv4：**IPv4 允许分片，因此 IP 标头中包含“不分片”标志。PMTUD 在 IPv4 中这样工作，沿着网络路径发送打开了“不分片”标志的测试数据包。如果路径上的任何路由器或设备丢弃该数据包，它将发回 ICMP 消息及其 MTU。源设备降低其 MTU 并发送另一个测试数据包。重复此过程，直到测试数据包足够小，遍历整个网络路径而不会丢失。

**IPv6：**对于不允许分片的 IPv6，PMTUD 的工作方式几乎相同。关键区别在于 IPv6 标头没有“不分片”选项，因此不设置这个标志。支持 IPv6 的路由器不会对 IPv6 数据包进行分片；因此，如果测试数据包超过 MTU，则路由器会丢弃数据包并发回相应的 ICMP 消息，而无需检查“不分片”标志。IPv6 PMTUD 发送越来越小的测试数据包，直到数据包可以遍历整个网络路径为止，就如在 IPv4 中一样。

## 什么是 MSS？

[MSS](https://www.cloudflare.com/learning/network-layer/what-is-mss/) 代表最大分段大小。MSS 由 TCP 在互联网的第 4 层（传输层）使用，而不是第 3 层。MSS 仅关注每个数据包中有效负载的大小。它是通过从 MTU 中减去 TCP 和 IP 标头的长度来计算的。

超过路由器 MTU 的数据包被分片或丢弃，超过 MSS 的数据包则始终会被丢弃。

若要进一步了解 MTU 和 MSS，请参阅[什么是 MSS？](https://www.cloudflare.com/learning/network-layer/what-is-mss/)