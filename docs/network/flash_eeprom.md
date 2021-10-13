[![img](http://file.elecfans.com/web1/M00/65/08/o4YBAFujh5aANOUmAAAx_O961hM610.png)](http://file.elecfans.com/web1/M00/65/08/o4YBAFujh5aANOUmAAAx_O961hM610.png)

时，然后才能再下一次，这么折腾一天也改不了几次。历史的车轮不断前进，伟大的EEP[ROM](http://www.elecfans.com/tags/rom/)出现了，拯救了一大批程序员，终于可以随意的修改ROM中的内容了。

EEPROM的全称是“电可擦除可编程只读存储器”，即Electrically Erasable Prog[ram](http://www.elecfans.com/tags/ram/)mable Read-Only Memory。是相对于紫外擦除的rom来讲的。但是今天已经存在多种EEPROM的变种，变成了一类存储器的统称。

狭义的EEPROM：

这种rom的特点是可以随机访问和修改任何一个字节，可以往每个bit中写入0或者1。这是最传统的一种EEPROM，掉电后数据不丢失，可以保存100年，可以擦写100w次。具有较高的可靠性，但是电路复杂/成本也高。因此目前的EEPROM都是几十千字节到几百千字节的，绝少有超过512K的。

Flash:

Flash属于广义的EEPROM，因为它也是电擦除的ROM。但是为了区别于一般的按字节为单位的擦写的EEPROM，我们都叫它Flash。

既然两者差不多，为什么[单片机](http://www.elecfans.com/tags/单片机/)中还要既有Flash又有EEPROM呢？

通常，单片机里的Flash都用于存放运行代码，在运行过程中不能改；EEPROM是用来保存用户数据，运行过程中可以改变，比如一个[时钟](http://www.elecfans.com/tags/时钟/)的闹铃时间初始化设定为12：00，后来在运行中改为6：00，这是保存在EEPROM里，不怕掉电，就算重新上电也不需要重新调整到6：00。

但最大区别是其实是：**FLASH按扇区操作，EEPROM则按字节操作**，二者寻址方法不同，存储单元的结构也不同，FLASH的电路结构较简单，同样容量占芯片面积较小，成本自然比EEPROM低，因而适合用作程序存储器，EEPROM则更多的用作非易失的数据存储器。当然用FLASH做数据存储器也行，但操作比EEPROM麻烦的多，所以更“人性化”的[MCU](http://www.elecfans.com/tags/mcu/)设计会集成FLASH和EEPROM两种非易失性存储器，而廉价型设计往往只有 FLASH，早期可电擦写型MCU则都是EEPRM结构，现在已基本上停产了。

在芯片的内电路中，FLASH和EEPROM不仅电路不同，地址空间也不同，操作方法和指令自然也不同，不论冯诺伊曼结构还是哈佛结构都是这样。技术上，程序存储器和非易失数据存储器都可以只用FALSH结构或EEPROM结构，甚至可以用“变通”的技术手段在程序存储区模拟“数据存储区”，但就算如此，概念上二者依然不同，这是基本常识问题。

EEPROM：电可擦除可编程只读存储器，Flash的操作特性完全符合EEPROM的定义，属EEPROM无疑，首款Flash推出时其数据手册上也清楚的标明是EEPROM，现在的多数Flash手册上也是这么标明的，**二者的关系是“白马”和“马”**。至于为什么业界要区分二者，主要的原因是 Flash EEPROM的操作方法和传统EEPROM截然不同，次要的原因是为了语言的简练，非正式文件和口语中Flash EEPROM就简称为Flash，这里要强调的是白马的“白”属性而非其“马”属性以区别Flash和传统EEPROM。

Flash的特点是结构简单，同样工艺和同样晶元面积下可以得到更高容量且大数据量下的操作速度更快，但缺点是操作过程麻烦，特别是在小数据量反复重写时，所以**在MCU中Flash结构适于不需频繁改写的程序存储器**。

很多应用中，**需要频繁的改写某些小量数据且需掉电非易失，传统结构的EEPROM在此非常适合，**所以很多MCU内部设计了两种EEPROM结构，FLASH的和传统的以期获得成本和功能的均衡，这极大的方便了使用者。随着ISP、IAP的流行，特别是在程序存储地址空间和数据存储地址空间重叠的MCU系中，现在越来越多的MCU生产商用支持IAP的程序存储器来模拟EEPROM对应的数据存储器，这是低成本下实现非易失数据存储器的一种变通方法。为在商业宣传上取得和双EEPROM工艺的“等效”性，不少采用Flash程序存储器“模拟”（注意，技术概念上并非真正的模拟）EEPROM数据存储器的厂家纷纷宣称其产品是带EEPROM的，严格说，这是非常不严谨的，但商人有商人的目的和方法，用Flash“模拟”EEPROM可以获取更大商业利益，所以在事实上，技术概念混淆的始作俑者正是他们。

[![img](http://file.elecfans.com/web1/M00/65/08/o4YBAFujh5aAWXSgAABReclJ4yA584.png)](http://file.elecfans.com/web1/M00/65/08/o4YBAFujh5aAWXSgAABReclJ4yA584.png)

 