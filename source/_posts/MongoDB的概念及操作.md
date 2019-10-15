---
title: MongoDB的概念及操作.md
date: 2019-09-16 22:30:19
tags: [mongodb]
categories: 数据库
---
# MongoDB的概念及操作
## MongoDB的概念
MongoDB从结构上有三大概念：数据库(database)、集合(collection)、文档(document)，数据库和文档不需要手动创建，创建文档时，如果集合或者数据库不存在会自动创建数据库。

**数据库：**  仓库，可在仓库中创建多个集合
**集合：**  数据，可在集合中存放多个文档
**文档：**  数据库最小单位，存储操作的内容都是文档

## 操作API

MongoDB的操作可在可视化与非可视化客户端完成，本文介绍在终端非可视化面板上，即命令行操作。


### 数据库操作

```javascript
// 打开数据库面板
$ mongo
>
// 查看所有数据库
> show dbs/databases
// 进入/创建数据库
> use <dbname>
// 删除数据库
> db.dropDatabase()
```

### 集合操作
```javascript
// 新建集合
> createCollection('unmber')
// 查看所有集合
> show collections
// 删除集合
> db.collectionName.drop()
```
### 文档操作
#### 新增文档
当插入一个文档时没有指定_id，则文档会根据时间戳生成一个_id的值，如果指定了_id，则使用指定的_id
```javascript
// 新增一条
> db.<collectionName>.insertOne(obj)
// 插入一条或多条
> insert(Obj|Array)
// 批量新增
> insertMany(arr)
```

#### 查找文档
```javascript
// 查找所有文档
> db.<collectionName>.find()
// 查询符合条件的第一条文档
> findOne(obj)
// 查询符合条件的条数
> db.<collectionName>.count()
> db.<collectionName>.find(obj).count()
```
#### 更新文档
```javascript
/**
 * query : update的查询条件，类似sql update查询内where后面的。
 * update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
 * upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
 * multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
 * writeConcern :可选，抛出异常的级别。
 */
> db.collection.update(
    <query>,
    <update>,
    {
        upsert: <boolean>,
        multi: <boolean>,
        writeConcern: <document>
    }
)
/**
 * save() 方法: 方法通过传入的文档来替换已有文档
 * document : 文档数据。
 * writeConcern :可选，抛出异常的级别。
 */
> db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)

// eg
// 只更新第一条记录：
> db.col.update( { "count" : { $gt : 1 } } , { $set : { "test2" : "OK"} } );
// 全部更新：
> db.col.update( { "count" : { $gt : 3 } } , { $set : { "test2" : "OK"} },false,true );
// 只添加第一条：
> db.col.update( { "count" : { $gt : 4 } } , { $set : { "test5" : "OK"} },true,false );
// 全部添加进去:
> db.col.update( { "count" : { $gt : 5 } } , { $set : { "test5" : "OK"} },true,true );
// 全部更新：
db.col.update( { "count" : { $gt : 15 } } , { $inc : { "count" : 1} },false,true );
// 只更新第一条记录：
db.col.update( { "count" : { $gt : 10 } } , { $inc : { "count" : 1} },false,false );
```
#### 删除文档
```javascript
// remove
> db.<collectionName>.remove(
    <query>, //可选 查询条件 Object
    {
       justOne: <boolean>,//可选 是否只删一个
        writeConcern: <document> // 可选 抛出异常的级别
    } 
)
// deleteOne 删除符合条件的第一条文档
> db.<collectionName>.deleteOne(obj)
// deleteMany
> db.<collectionName>.deleteMany(obj)
```
## 操作符
### 逻辑运算
#### 逻辑运算与增删
|符号|意义|示例|
| :-: | :-: | :-: |
|$gt| 大于|逻辑运算|
|$gte| 大于等于|逻辑运算|
|$lt| 小于|逻辑运算|
|$lte| 小于等于|逻辑运算|
|$or| 或| emp.find({ $or: [{sal: { $gte: 2500 }}, { sal: { $lte: 1000 } }] }) |
|$inc| 自增| emp.update({ sal: { $lte: 1000 } }, { $inc: { sal: 400 } }) |
|$set| 修改value/新增{key:value}|emp.update({ sal: { $lte: 1000 } }, { $inc: { sal: 400 } }) |
|$set| 修改value/新增{key:value} |增删|
|$unset| 删除key|增删|
|$push| 向数组添加一个值|增删|
|$addToSet| 向数组添加一个不存在的值|增删|

#### 取数方法
```javascript
// 取出n条数据
limit(n)
// 跳过第m条之前的数据
skip(m)

function getDataList(page, page_size) {
    var skip = ( page - 1 ) + page_size;
    var data = db.<collection>.find({/*筛选条件*/});
    return {
        data: data.limit(page_size).skip(skip),
        total: data.count()
    };
}

```
## 排序和映射
### 排序
默认：如果不指定sort()，则按照_id排序，而_id = 时间戳 + 机器码组成，所以实际上默认是按照创建时间排序。
```javascript
//先按照 工资(sal) 升序；如果工资相同，再按照编号(empno) 降序排列
emp.find().sort({ sal: 1, empno: -1 }) // 1 升序， -1 降序
```
### 映射
```javascript
//返回 工资(sal) >= 10000 的员工姓名 如果想忽略_id，可以尝试：
emp.find({ sal: { $gte: 10000 } }, { ename: 1, _id: 0 }) // 1 允许 0 禁止
```

## 导入导出数据库文件
### 导出数据库文件（备份数据库）
#### 语法
> $ mongodump -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -o 文件存在路径

    如果没有用户，可以去掉-u和-p。
    如果导出本机的数据库，可以去掉-h。
    如果是默认端口，可以去掉--port。
    如果想导出所有数据库，可以去掉-d。

#### 示例
导出所有数据库
> $ mongodump -h 127.0.0.1 -o ~/data/

导出指定数据库
> $ mongodump -h 192.168.1.108 -d test -o ~/data

### 导入数据库（恢复数据库）
#### 语法
> $ mongorestore -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 --drop 文件存在路径

    --drop：先删除所有的记录，然后恢复。
#### 示例
导入目录下所有数据
> $ mongorestore ~/data

导入指定数据
> $ mongorestore -d test  ~/data/test

### 导出表
#### 语法
> $ mongoexport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 -f 字段 -q 条件导出 --csv -o 文件名

    -f    导出指字段，以字号分割，-f name,email,age导出name,email,age这三个字段
    -q    可以根查询条件导出，-q '{ "uid" : "100" }' 导出uid为100的数据
    --csv 表示导出的文件格式为csv的，这个比较有用，因为大部分的关系型数据库都是支持csv，在这里有共同点

### 示例
导出整张表
> $ mongoexport -d test -c users -o ~/data/test/users.dat

导出表中部分字段
> $ mongoexport -d test -c users --csv -f uid,name,sex -o ~/data/test/users.csv

根据条件导出数据
```
> $ mongoexport -d test -c users -q '{uid:{$gt:1}}' -o  ~/data/test/users.json 
```
### 导入表
#### 语法
还原整表导出的非csv文件
> $ mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --upsert --drop 文件名 

    --upsert: 插入或者更新现有数据
    --drop: 先删除所有的记录，然后恢复

还原部分字段的导出文件
> $ mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --upsertFields 字段 --drop 文件名

    --upsertFields: 插入或者更新现有数据

还原导出的csv文件
> $ mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --type 类型 --headerline --upsert --drop 文件名 

导入json文件
> $ mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --file data.json 

#### 示例
还原导出的表数据
> $ mongoimport -d test -c users --upsert ~/data/test/users.dat

部分字段的表数据导入
> $ mongoimport -d test -c users  --upsertFields uid,name,sex  ~/data/test/users.dat 

还原csv文件
> $ mongoimport -d test -c users --type csv --headerline --file ~/data/test/users.csv 

