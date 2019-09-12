---
title: mongodb如何实现自增id.md
date: 2019-09-11 17:38:44
tags: [mongodb]
categories: [mongodb, 数据库]
---
# MongoDB如何实现自增id
MongoDB作为nosql中最热门的数据库，越来越多的人选择它，但是在事务上有着先天不足。例如用户id，用又臭又长的objectId又不方便，为了实现类似于MySQL的自增ID，可以建一个集合承担发号表的工作。

## Schema
Schema可以设计成这个样子
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
以用户集合举例，注册时这可以这样实现自增userId

```
// service/users.js
async newAndSave(name, password, email, type, active) {
    const idItem = await this.ctx.model.Ids.findOneAndUpdate(
      { name: 'user' },
      { $inc: { id: 1 } },
      { upsert: true, new: true }
    ).exec();
    const user = new this.ctx.model.User();
    user.name = name;
    user.id = idItem.id; // 自增id
    user.password = password;
    user.email = email;
    user.type = type;

    return user.save();
}
```
用MongoDB的$inc实现自增，findOneAndUpdate同步自增id表。
这样就完成了用户表自增ID的实现。
