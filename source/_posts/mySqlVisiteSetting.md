---
title: MySQL访问设置
date: 2017.12.03
tags: [MySQL]
categories: MySQL
---

# mySql访问设置
> 设置MySQL允许所有IP访问

```
$ mysql -u name -p //输入密码登录mysql

mysql>use mysql;

mysql>update user set host = '%' where user = 'root';

mysql>flush privileges;

mysql>select 'host','user' from user where user='root';

mysql>exit;
```
