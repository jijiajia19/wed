## 解决ssh: connect to host github.com port 22: Connection refused



当你在Linux环境下配置好git并链接到后，你想要把本地的代码上传到github中。但是当你push的时候，会出现失败的情况。

> ssh git@github.com

使用上面的命令查看详细错误信息，得到以下结果


解决方法
然后我们进入.ssh的配置目录查看，发现ssh目录里少了配置文件config。

找到原因后我们进入.ssh的目录，使用命令“touch config”创建一个配置文件，并写入你github的配置信息。（xxxxx@xx.com是你github的注册邮箱）

> Host github.com  
> User xxxxx@xx.com  
> Hostname ssh.github.com  
> PreferredAuthentications publickey  
> IdentityFile ~/.ssh/id_rsa  
> Port 443

现在再使用ssh git@github.com查看与github的连接状态，可能出现错误Bad owner or permissions on

这是因为你创建的配置文件config的权限不够。所以我们需要修改其权限。使用下面命令。

> sudo chmod 600 config

现在我们再尝试查看连接状态发现已经成功连接。

接下来就可以成功的push你的代码到github了。