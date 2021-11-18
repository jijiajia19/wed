## 广域网

Lan:RFC1918定义的局域网网段

广域网：ISP

Cisco SP:MPLS、BGP、ISIS



WAN拓扑：

- HUB and SPOKE 总公司流量监控
- FULL MESH   分公司依赖VOIP，使用VOIP的时候
- Partial MESH 鉴于两者之间的方案



WAN连接类型

- P2P专线（可以是串口）
- ISDN (语音和串口数据)
- MPLS(多标签路由协议)



WAN物理接口：

RJ11 电话线（DSL modem）

RJ45 双绞线

v.35串口



CPE能够购买不同的服务，来进行跟ISP的广域网连接

PPP HDLC类似二层协议

- HDLC 思科私有协议，串口协议

- P2P(PPP公开协议)

  - PPP验证有PAP（不安全）、CHAP

    > 用户名为对方的hostname
    >
    > Router(config)#hostname R1
    >
    > R1(config)#username R2 password cisco
    >
    > R1(config)#int s0/1/0
    >
    > R1(config-if)#en
    >
    > R1(config-if)#encapsulation ppp
    >
    > R1(config-if)#
    >
    > %LINEPROTO-5-UPDOWN: Line protocol on Interface Serial0/1/0, changed state to down
    >
    > 
    >
    > R1(config-if)#
    >
    > %LINEPROTO-5-UPDOWN: Line protocol on Interface Serial0/1/0, changed state to up
    >
    > 
    >
    > R1(config-if)#ppp auth
    >
    > R1(config-if)#ppp authentication chap

    > Trouble Shooting
    >
    > 1、协议不匹配，HDLC需要从新知道个auth类型
    >
    > 2、密码不一致，LCD closed表示密码错误
    >
    > PPP不是以太网协议，不需要MAC
    >
    > 以太网不通网段，还是可以通信
    >
    > 
    >
    > 

- BGP(三层协议)

  - EBGP (AS之间)
  - IBGP（AS内部）

  很灵活，而且能够控制流量

  network 在BGP里面表示宣告接口

  > ISP(config)#router bgp 1
  >
  > ISP(config-router)#nei 192.168.1.2 remote-as 100
  >
  > ISP(config-router)#nei 192.168.2.2 remo
  >
  > ISP(config-router)#nei 192.168.2.2 remote-as 200
  >
  > ISP(config-router)#network 10.0.0.0 net
  >
  > ISP(config-router)#network 10.0.0.0 
  >
  > ISP(config-router)#network 10.0.0.0 mask 255.255.255.0

