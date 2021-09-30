

# gitlab pages runner **.gitlab-ci.yml** 配置文件内容



> ```
> pages:
>   stage: deploy
>   script:
>     - mkdir .public
>     - cp -r * .public
>     - mv .public public
>   artifacts:
>     paths:
>       - public
>   only:
>     - main
> ```

