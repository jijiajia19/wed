# GitLab Runner 安装与配置

准备工作[](#)
---------

下载安装包

    # Linux x86-64
    sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
    
    # Linux x86
    sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-386
    
    # Linux arm
    sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm


​    
​    

如果是离线安装的话，可以手工联网下载，然后放到内网中，放到 `/usr/local/bin` 目录下，并命名为 `gitlab-runner`。

    # 赋予可执行权限
    sudo chmod +x /usr/local/bin/gitlab-runner
    
    # 创建 GitLab CI 用户
    sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
     
    # 安装
    sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
    
    # 运行
    sudo gitlab-runner start


​    

注册 Runner[](#)
--------------

首先需要准备URL和Token，可以在 GitLab 项目的 `settings->CI/CD->Runners settings` 中找到

    # 注册
    sudo gitlab-runner register
    
    # 输入本地的 gitlab URL
    Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
    https://gitlab.com
    
    # 输入 Token
    Please enter the gitlab-ci token for this runner
    xxx
    
    # 输入 tag, 注意要跟 job 的 tag 一致，后续详细说明
    Please enter the gitlab-ci tags for this runner (comma separated):
    my-tag,another-tag
    
    # 选择 executor, 
    Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell:
    docker


### 使用 tags[](#)

Runner 默认只会在配置了和自身 tags 一致的项目上运行，是为了防止 Runner 运行在大量项目上出现问题。

同时可以在 Runner 中取消该设置，允许 Runner 运行在无 tags 的项目上，配置如下

> 1.  Visit your project’s **Settings ➔ CI/CD**
> 2.  Find the Runner you wish and make sure it’s enabled
> 3.  Click the pencil button
> 4.  Check the **Run untagged jobs** option
> 5.  Click **Save changes** for the changes to take effect



> 1.  It’s possible, but in most cases it is problematic if the build uses services installed on the build machine
> 2.  It requires to install all dependencies by hand
> 3.  For example using [Vagrant](https://www.vagrantup.com/docs/virtualbox/)

具体详细可参考[GitLab 中配置 Runner](https://docs.gitlab.com/runner/executors/>这里</a></p>
<h2 id=)[](#)

在 GitLab 项目中新增 `.gitlab-ci.yml` ，可以选择预先设置好的模版。
