gitlab修改密码，不会报错: ERROR: "rails console" was called with arguments \["production"\]
==================================================================================

2021年2月3日 1249点热度 6人点赞 0条评论

**执行命令：**

sudo gitlab-rails console -e production

**这个 -e 的参数一定不能少。**
**命令比较慢，几十秒后，会进入控制台。执行如下操作：**

    irb(main):001:0> u=User.where(id:1).first
    => #<User id:1 @root>
    irb(main):003:0> u.password=12345678
    => 12345678
    irb(main):004:0> u.password_confirmation=12345678
    => 12345678
    irb(main):005:0> u.save!
    Enqueued ActionMailer::DeliveryJob (Job ID: 15c3c8de-e839-4874-8104-d72dbe224756) to Sidekiq(mailers) with arguments: "DeviseMailer", "password_change", "deliver_now", #<GlobalID:0x00007f65d5b944d8 @uri=#<URI::GID gid://gitlab/User/1>>
    => true
    irb(main):006:0> quit
