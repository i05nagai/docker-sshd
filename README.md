## docker-sshd
home directory to sup

## Usage
Configure environment variables defined in 

```
./docker_run.sh
```

```
ssh -i /path/to/prviate/key -p 12345 <github-account>@home
```

## Environment variables
* HOME_USERS
    * list of `<github-account>:[<shell>]` separated by space
    * e.g. `hoge:/bin/zsh fuga:`
* HOME_SUDOERS
    * list of `<github-account>` separeted by space
    * e.g. `hoge fuga`
* DOCKER_HOST

## Reference
