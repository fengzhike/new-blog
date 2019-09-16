---
title: MongoDB实现自增ID
date: 2019-08-06 17:41:09
tags: [mongodb, mongose, egg-mongose]
categories: 数据库
---

MongoDB是基于分布式文件存储的数据库，在NoSQL中排名第一，是最流行的NoSQL，有高性能、轻量级、易于扩展的特性，运用范围广。我们知道，mongodb有自己的ObjectId，没有类似于MySQL中的自增能力，当我们需要自增字段时，比如userid，ObjectId过长不方便使用，此时我们需要自定义自增长id。

本文以egg-mongose为例，以findOneAndUpdate实现自增id；

## Schema
设计ids的Schema，用于发号

```
// model/ids.js
module.exports = app => {
    const mongoose = app.mongoose;
    const Schema = mongoose.Schema;

    const IdsSchema = new Schema({
        name: { type: String },
        id: { type: Number }
    });

    IdsSchema.index({ name: 1 });

    return mongoose.model('Ids', IdsSchema);
};
```

## 使用
保存document时，查询IdsSchema，没有document创建新的，有的话自增返回自增后的document。

```
/**
* findOneAndUpdate($1, $2, $3):
* params:
* $1: query
* $2: $inc 自增
* $3: options: upsert--找不到时创建新的document; new--返回运算后的新值
*/
const idItem = await this.ctx.model.Ids.findOneAndUpdate({'name': 'user'}, {$inc:{'id':1}}, {upsert:true, new: true}).exec()
let user.id = idItem.id;
...
```

如此，便完成了一个自增id的实现。
