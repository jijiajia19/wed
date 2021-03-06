

#### 共享式以太网与交换式以太网的区别

​    在早期的共享式的以太网中，各个主机之间用的是同轴电缆进行通信，并且是共用一条同轴电缆，共用一条同轴电缆也就意味着这些主机都处在同一个冲突域中，何为冲突域？现在把同轴电缆比作一条车道，把终端比作车辆，但这条车道同时只能允许一台车辆通过，两台车辆同时上路是不是会撞车？是不是只能等这台车辆通过了才让下一辆车辆通过，上路的车辆越多通行的速度越慢，这就是为什么在冲突域网络中接入的主机越多速度也就越慢，因为局域网中所有的接入终端都共享总线的带宽，接入的终端越多每台终端的带宽也就越少，比如一条总线带宽的速率是100Mbps，这一条线路接入了两台主机，那么每台主机的速率是50Mbps，如果接入10台呢？那么每台主机能用的带宽是不是只有10Mbps了，是不是接入的主机越多速度越来越慢，局域网中的所有主机共享总线的带宽，这个时候的接入设备一般是HUB和集线器之类的物理层设备；

​    到了后来的交换式以太网，交换机的各个端口隔离了冲突域保证了各个端口的独立带宽，就好比单车道升级多车道，各走各的互不影响，接入再多的终端也不会导致速率变慢，这个时候的接入设备一般是二层交换机和三层交换机。



#### 交换机的MAC地址学习过程

前面我们知道了交换机可以隔离冲突域，保证了各个终端的带宽互不影响，也就是说交换机进行了一个逻辑的转发过程，转发数据帧进行了有选择性的转发，而转发的依据就是MAC地址，何为MAC地址？MAC地址就是一台设备的物理地址，并且是固化在网卡的ROM芯片中不易修改的，并且每台设备的物理地址是该网络中独一无二的地址；然后在交换机中都有一个表，叫MAC地址表，这个表记录了MAC地址对应的出接口，就好像我可以查地图知道去你家的路怎么走；但是在交换机刚启动的时候这个表是空的，是空的怎么办？是不是得学？就好比人刚出生什么东西都不会，是不是得后天进行学习？交换机也是，在交换机启动后会有一个MAC地址学习的过程

![img](https://img-blog.csdn.net/20160111110301210?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

图中的PCA发出一个数据帧，交换机收到这个数据帧的时候，会把PCA发出的数据帧中的源MAC地址与收到这个帧的端口关联起来记录到MAC地址表里面去，然后交换机把该数据帧从除了收到该数据帧的其它所有接口发送出去；同理，当PCB发送一个数据帧的时候，交换机会把接收到的数据帧中的源MAC地址与收到该数据帧的接口绑定起来，然后记录到MAC地址表里面去，形成了一个MAC地址表。





####     以太网工作在数据链路层，通过不同的传输介质和冲突检测方法，为其上的网络层、数据链路层等提供高效的服务。