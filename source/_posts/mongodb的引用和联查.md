---
title: MongoDB的引用和联查
date: 2019-09-12 15:34:53
tags: [mongodb, mongose]
categories: 数据库
---
# MongoDB的引用和联查

MongoDB中可以通过引用和联查实现一对多、多对多的应用场景。比如常见的关注和粉丝功能，一个人关注目标是有限的，但是粉丝是不确定的，粉丝量过大的用户，如果在用户集合里面存一个数组是很影响性能和体验的。

通过分析，我们可以在user的集合设置关注属性，通过过滤关注属性来查询某个用户的粉丝

## 关注实现
在UserSchema中添加flowing属性
```
// models/users.js

const userSchema = new Schema({
    name: { type: String, required: true },
    password: { type: String, required: true, select: false },
    ...

    following: {
      type: [{ type: String, ref: 'User' }],
      select: false,
      },
    ...
})
```
下面可以在控制器中获取某用户的关注列表
```
// controllers/users.js

async listFollowing(ctx){
    const user = await User.findById(ctx.params.id).select('+following').populate('following');
    if (!user) { ctx.throw(404, '用户不存在'); }
    ctx.body = user.following;
}

```
Schema中的ref实现了表的引用，此例中的following属性关联User集合，在使用过程中，populate通过ref实现了对其指定的User表的联查。

## 粉丝实现
下面聊聊粉丝的设计：

由于粉丝不是某个用户主动操作，总数有非常大的可能性，设成User的一个属性在超大数据时就不合适了。换个思路，user里面关注该用户的即为粉丝
```
// controllers/users.js

async listFollowers(ctx) {
    const users = await User.find({ following: ctx.params.id });
    ctx.body = users;
}
```
思路一变，豁然开朗





















c
