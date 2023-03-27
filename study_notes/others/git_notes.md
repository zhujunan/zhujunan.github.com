git笔记

***

* workspace 工作区
* staging area 暂存区
* local repository 本地仓库
* remote repository 远程仓库

# git 配置信息

```
git config --list

设置用户名与邮箱
git config --global user.name "username"
git config --global user.email "useremail"
```

# git 库及分支管理

* git init

使用当前目录作为 Git 仓库

* git branch

```
git branch                   # 查看本地分支
git branch -a                # 查看所有分支
git branch -v                # 查看本地分支
git branch -r                # 查看远程分支

git branch <branchName>      # 创建本地分支
git branch -m old new        # 重命名分支,M强制重命名
git branch -u origin xxx     # 关联远程分支
git branch -d branchname     # 删除本地分支
git branch -d -r branchname  # 删除远程分支
git branch --set-upstream-to=origin/<branch> feture-test   # 建立本地分支与远程分支的联系
```

* git checkout

```
git checkout .               # 放弃本地修改
git checkout branchname      # 切换到分支
git checkout -b branchname   # 创建新分支
git checkout -t branchname   # 切换到远程分支
```

* git merge

```
git merge branchname         # 将分支合并到主分支中
```

# git 修改管理

* 基本操作

```
git add           # 添加文件到暂存区
git commit -m     # 提交暂存区到本地仓库
git status        # 查看仓库当前的状态，显示有变更的文件
git diff          # 比较文件的不同，即暂存区和工作区的差异
git reset         # 回退版本
git rm            # 将文件从暂存区和工作区中删除
git mv            # 移动或重命名工作区文件
git log           # 查看历史提交记录
git blame <file>  # 以列表形式查看指定文件的历史修改记录
git push -f       # 上传修改
git reset --hard

git clean                # 删除Untracked files，-n查看 -f强制删除 -d包括文件夹
git fsck –lost-found	   #	找回被删除后的commit_id
```

* git rebase

```
git rebase master
将commit还原为patch包，更新master后重新打patch包
因为改变了commit历史，最好保证rebase的所有commits历史还没有被push过

git add
git rebase --continue
git rebase --abort

git pull --rebase
```

* 暂存当前修改

```
git stash
git stash list
git stash show     # 显⽰做了哪些改动，默认show第一个存储
git stash save '注释'     # 添加注释
git stash pop     # 弹出上次的暂存
git stash apply stash@{$num}     # 不会将内容从堆栈中删除，适合用与多个分支的场景
git stash drop stash@{$num}     # 从堆栈中移除指定的stash
git stash clear
```

# git 远程操作

```
git remote        # 远程仓库操作
git fetch --all   # 从远程获取代码库
git pull          # 下载远程代码并合并
git push          # 上传远程代码并合并
```

* git remote

```
git remote add
git remote -v
git remote show huawei
git remote show origin
```

# git 密钥

cat /home/zhujunan/.ssh/id_rsa.pub

ssh 公钥：/home/zhujunan/.ssh/id_rsa.pub

ssh-keygen -t rsa -C zhujunan@xxxx.com

# git提交规范

业界通用的Git提交规范：

```
<type>(<scope>):<subject>

type
类别标识
sync：同步主线或分支的bug
merge：代码合并
revert：回滚到上一个版本
chore：构建过程或辅助工具的变动
test：增加测试
perf：优化相关，比如提升性能、体验
refactor：重构
style：格式
docs：文档
fix / to：修复bug，可以是QA(Quality Assurance)发现的bug，也可以是研发自己发现的bug
feat：新功能（feature）

scope
影响的范围，比如数据层、控制层、视图层等，视项目不同而不同。
例子
在JAVA，可以是Controller，Service，Dao等。
在Angular，可以是location，browser，compile，compile，rootScope， ngHref，ngClick，ngView等。
如果你的修改影响了不止一个scope，你可以使用*代替。

subject
简短描述，结尾不加句号或其他标点符号。

样例
feat(Controller):用户查询接口开发
```
