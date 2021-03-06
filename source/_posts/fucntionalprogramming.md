---
title: 函数式编程入门
date: 2017.11.25
tags: [前端]
categories: 函数式编程
---

# 函数式编程入门 Javascript Fucntional Programming
## 一、范畴论
函数式编程的起源是范畴论（Category Theory）。

范畴论认为世界上所有的概念体系，都快抽象成一个个的‘范畴’

1. 范畴
    * 维基百科： 范畴是使用箭头链接的物体

        一切事物，找出对应的关系，就能构成一个范畴

    * 范畴包括事物和事物之间对应的关系
    * 箭头表示范畴成员之间的关系，正式的名称叫做‘态射’。范畴论认为，同一个范畴的所有成员，就是不同状态的变形，通过‘态射’,一个成员可以变成另一个成员

说人话：    
**集合**：一对有共有特点的元素的整体
**范畴**：这个集合+这个集合中元素相互映射的关系①

    ①--此关系名为“态射”，是范畴成员之间的映射关系，成员之间通过此关系可以相互转化

2. 数学模型

>      ·所有成员是一个集合
       ·变形关系是函数

范畴论是集合论更上层的抽象，简单的理解就是 “集合+函数”
 理论上通过函数，就可以从范畴的一个成员，算出其他所有成员  


3. 范畴与容器
我们把范畴想象成一个容器，里面包含两样东西

>   ·值（value）
    ·值得变形关系，也就是函数

* 用代码定义一个范畴

```
    class Category{
        constructor(val){
            this.val = val
        }
        addOne(x){
            return x+1
        }
    }

```
上面代码中，Category是一个类，也是一个容器，里面包含一个值（this.val）和一种变形关系(addOne)。这里的范畴就是彼此之间相差1的数字
这些 “数字” 是一个集合 “相差1”是一个态射  组合起来就是范畴，也叫容器

4. **范畴论**与**函数式编程**的关系
**范畴论**使用函数表达范畴之间的关系

**范畴论**发展出一套函数运算方法，起初只用于数学，后来在计算机上实现了，就叫做**函数式编程**


***本质上，**函数式编程**只是**范畴论**的运算方法，跟数学逻辑、微积分、行列式是同一类的东西，都是数学方法，知识碰巧能用来写程序***

* 结论：
    1. **函数式编程**是一种函数之间的数学运算，原始目的就是求值，不做其他事情，否则无法满足函数运算法则
    2. 在**函数式编程**里，函数值是一个管道（pipe），进去一个值，出来一个值。无副作用


## 二、函数的合成与柯里化

函数式编程有两个最基本的运算法则：合成和柯里化。

### 函数的合成
1. 函数合成的运算
```
    y = f(x);
    z = g(y);

    z = g(f(x))    
```
这里x通过f和g的两次转化才变成z，把过程中所有步骤合并起来，就叫做 “函数的合成”（compose）

    其中x和y之间的变形关系是函数f，y和z之间的变形关系是函数g，那么x和z之阿金的关系就是g和f的合成函数g·f。

合成两个函数的代码如下

```
    const compose = function (f,g){
        return function (x){
            return f(g(x))
        }
    }
```
2. 函数合成的结合律

<img src='/static/img/compose.jpg' width = 400/>

```
    compose(f,compose(g,h)) <=>
    compose(compose(f,g),h) <=>
    compose(f,g,h)
```


### 函数的柯里化

在函数的合成中，一个参数的函数很好运算 如 f(x)和g(x)合成为f(g(x))。如果被合成函数能接收多个参数如：f(x,y)和g(a,b,c)，合成就非常麻烦了

针对多参数函数的运算，我们可以使用**柯里化**，在进行运算

1. 函数的柯里化的运算
**柯里化**，就是把一个多参数的函数，转化为单参数的函数

```
    function add(x,y){
        return x+y;
    }
    add(1,2) //3
```

对add进行柯里化

```
    function addX(y){
        return function (x){
            return x+y;
        }
    }
    addX(2)(1) //3
```

**柯里化**使所有的函数都只接受一个参数。

2. 应用场景

**柯里化**使函数分为多步执行，在实际开发中，可以把公共层面的运算和业务层面的运算分开
```
    export function abc(x){
        return function (json){
            //do something
        }
    }
```

框架工具调用abc 会把基础对象返回来，然后跟实际业务数据对接处理，这个Redux有很好的实现，详细请看本博客关于redux的描述,这里不多赘述

## 三、函子
函数可以作用于同范畴中做值的转换，还可以将一个范畴转成另一个范畴。

**函子**是范畴间转换的基本单位


1. 函子的概念
函子是函数式编程里面最重要的数据类型，也是基本的运算单位和功能单位。
函子首先是一种范畴，也就是一个容器，包含了值和变形关系。***它的变形关系可以依次作用于每一个值，将当前容器变形成另一个容器***

>   函子（人话版）：一个拥有map方法的范畴A，可以用map方法接收一个外部函数f,把自己所有成员按f规则转化成新成员，从而达到把自己转化成范畴B的目的

>   这个范畴A就是函子



<img src='/static/img/functor.jpg' width = 400/>

上图中，左侧的圆圈就是一个函子，表示人名的范畴。外部传入函数f，会转成右边表示早餐的范畴。


<img src='/static/img/functor2.jpg' width = 300/>

上图中，函数f完成值的转换（a到b），将它传入函子，就可以实现范畴的转换（Fa到Fb）。

2. 函子代码的实现

任何有map方法的数据结构都可以当做函子的实现

```
    class Functor {
        constructor(val) {
            this.val = val;
        }

        map(f) {
            return new Functor(f(this.val));
        }
    }
```

上面代码中，Functor是一个函子，他的map方法接收函数f作为参数，然后返回一个新的函子，包含的值是被f处理过的（f(this.val)）

***一般约定，函子的标志就是容器具有map方法。该方法将容器里面的每一个值都映射到另一个容器***

下面是一些示例。

```
    (new Functor(2)).map(function (two) {
        return two + 2;
    });
    // Functor(4)

    (new Functor('flamethrowers')).map(function(s) {
        return s.toUpperCase();
    });
    // Functor('FLAMETHROWERS')

    (new Functor('bombs')).map(_.concat(' away')).map(_.prop('length'));
    // Functor(10)
```

示例说明，函数式编程里面的运算，都是通过函子完成的，即运算不直接针对值，而是针对这个值的容器---函子。
函子本身具有对外接口（map方法），函数就是运算符，通过对接口接入容器，引发容器里面值得变形

学习函数式编程，就是学习函子的各种运算，由于可以把运算方法封装在函子里面，所以衍生出各种不同函子，有多少运算就有多少种函子
## 四、of方法
上面的例子生成函子的时候，用了new命令。new命令是面向对象编程的标志

*** 函数式编程一般约定，函子有一个of方法，用来生成新的容器。***

用of替换new

```
    Functor.of = function(val){
        return new Functor(val)
    }
```

前面的例子可以改为

```
    Functor.of(2).map(function(two){
        return two+1
    })
    //Functor(4)
```
这么玩就更像函数式编程了

## 五、Maybe函子
函子的map可以接收各种函数来处理内部的值。如果内部的值为空null，而外部函数同时没有处理空值的机制，就会报错

```
    Functor.of(null).map(function (s) {
        return s.toUpperCase();
    });
    // TypeError
```
null.toUpperCase 报错
1. 下面是Maybe函子的实现
Maybe函子在map方法中设置了空值检查机制。

```
    class Maybe extends Functor {
        map(f) {
            return this.val ? Maybe.of(f(this.val)) : Maybe.of(null);
        }
    }
    Maybe.of = function (val){
        return new Maybe(val);
    }
```
2. 应用
此时对Maybe函子就不会报错了

```
    Maybe.of(null).map(function(s){
        return s.toUpperCase()
    })
    //Maybe(null)
```

## 六、Either函子
Either函子是解决函数式编程里的条件运算的

Either函子内部有两个值（左值，右值）。右值不存在使用左值，左值是默认值
1. Either函子的实现

```
    class Either extends Functor{
        constructor(left,right){
            this.left = left;
            this.right = right;
        }
        map(f){
            return this.right?
            Either.of(this.left,f(this.right)):
            Either.of(f(this.left),this.right)
        }
    }

    Either.of = function (left,right){
        return new Either(left,right);
    }

```

2. Either函子的应用

```
    var addOne = function (x){
        return x+1;
    }
    Either.of(5,6).map(addOne);
    // Either(5,7)
    Either.of(1,null).map(addOne);
    // Either(2,null)
```
3. Either最常见的用途是提供默认值,

```
    Either
    .of({address: 'xxx'}, currentUser.address)
    .map(updateField);
```

4. 用Either函子替代 try..catch

```
    function parseJSON(josn){
        try{
            return Either.of(null,JSON.parse(json))
        }catch(e){
            return Either.of(e, null);
        }
    }
```
上面代码中，左值为空，就表示没有出错，否则左值会包含一个错误对象e。一般来说，所有可能出错的运算，都可以返回一个 Either 函子。

## 七、ap函子

函子里面的值，有可能是函数

```
    function addTwo(x) {
        return x + 2;
    }

    const A = Functor.of(2);
    const B = Functor.of(addTwo)
```
上面代码中，函子A内部的值是2，函子B内部的值是函数addTwo。
1. ap函子的实现

函子A的值按函子B中的值（函数）进行运算时，就要用到ap（applicative）函子了

```
    class Ap extends Functor{
        ap(F){
            return Ap.of(this.val(F.val));
        }
    }
    AP.of = function (val){
        return new Ap(val)
    }
```
此处 Functor是val为函数的B函子，F为val为要计算数据的A函子
***ap函子接收的不是函数，而是另一个函子。****

2. ap函子的应用

```
    Ap.of(addTwo).ap(Functor.of(2))
    // Ap(4)
```

3. 函子实现链式操作

ap函子的意义在于，对多参数的函数，可以从多个容器中取值，实现函子的链式操作。

```
    function add(x){
        return function (y){
            return x+y;
        };
    }
    Ap.of(add).ap(Maybe.of(2)).ap(Maybe.of(3));
```
上述代码是add柯里化以后的形式，一共要两个参数，还有另外一种写法

```
    Ap.of(add(2)).ap(Maybe.of(3));
```

## 八、Monad函子
1. Monad解决函子里面包含函子运算问题

```
    Maybe.of(
        Maybe.of(
            Maybe.of({name: 'Mulburry', number: 8402})
        )
    )
```
上面的函子嵌套三个Maybe，如果要去之，就要连续取三次this.val 此时出现了Monad

***Monad的作用是，总是返回一个单层的函子***

2. Monad函子的实现

Monad函子有一个flatMap方法，与map的方法作用相同，唯一的区别是的如果生成了嵌套函子，他会取出后者内部的值，保证返回的永远是一个单层容器


```
    class Monad extends Functor{
        join(){
            return this.val
        }
        flatMap(f){
            return this.map(f).join();
        }
    }
```
如果f返回的是一个函子，this.map(f)就会生成一个嵌套的函子，所以join方法保证了flatMap方法总是返回一个单层的函子。嵌套的函子会被铺平

## 九、IO操作
Monad函子的重要作用是实现I/O操作

I/O是不纯的操作，普通的函数式编程没法做，把IO写成Monad函子，通过它来完成

```
    var fs = require('fs');

    var readFile = function(filename){
        return new IO(function(){
            return fs.readFileSync(filename,'utf-8');
        })
    }
    var print = function (x){
        return new IO(function(){
            console.log(x)
            return x
        })
    }
```
上面代码，读文件和打印本身都是不纯的操作，但是readfile和print趋势纯函数，因为他们总是返回IO函子。

如果IO函子是一个monad，具有flatMap方法，那么我们就可以向下面这样调用函数

```
    readFile('./user.txt')
    .flatMap(print)
```

如此完成了不纯的操作，flatMap返回的还是一个IO函子，所以表达式是纯的。一个纯的表达式完成了一个带有副作用的操作，这就是Monad的作用

返回的还是IO函子，所以可以实现连式操作，打错书库里面 flatMap被改名chain

```
    var tail = function(x) {
        return new IO(function() {
            return x[x.length - 1];
        });
    }

    readFile('./user.txt')
    .flatMap(tail)
    .flatMap(print)

    // 等同于
    readFile('./user.txt')
    .chain(tail)
    .chain(print)
```

读取user.txt,然后选取最后一行输出

## 十、函数式编程比较火的库

1. RxJS（建议试用体验）
    Rxjs 从诞生以来一直都不温不火，但它函数响应式编程 (Functional Reactive Programming，FRP)的理念非常先进， 虽然或许对于大部分应用环境来说，外部输入事件并不是 太频繁，并不需要引入一个如此庞大的 FRP 体系，但我们 也可以了解一下它有哪些优秀的特性

* cycleJS
    基于Rxjs ，ERP理念的框架，和React一样支持虚拟dom
* lodashJS（建议试用体验）

    一致接口、模块化、高性能 是underscore的fork

* underscore
    一个js工具库，提供了一整套函数式编程的实用功能，但是没有扩展任何的js内置对象
* Ramdajs
    全部是柯里化的

## 十一、实际应用场景

* 易调试、热部署、并发
* 单元测试
