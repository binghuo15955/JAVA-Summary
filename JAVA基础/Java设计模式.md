- [1. 创建模式](#1-创建模式)
  - [1.1 单例模式](#11-单例模式)
  - [1.2 工厂模式](#12-工厂模式)
  - [1.3 抽象工厂模式](#13-抽象工厂模式)
  - [1.4 建造者模式](#14-建造者模式)
  - [1.5 原型模式](#15-原型模式)
- [2. 结构模式](#2-结构模式)
  - [2.1 适配器模式](#21-适配器模式)
  - [2.2 代理模式](#22-代理模式)
    - [静态代理](#静态代理)
    - [动态代理](#动态代理)
      - [DynamicProxy](#dynamicproxy)
      - [InvocationHandler](#invocationhandler)
      - [DemoTest](#demotest)
    - [Cglib代理(Code Generation Library)](#cglib代理code-generation-library)
  - [2.3 组合模式](#23-组合模式)
  - [2.4 装饰器模式](#24-装饰器模式)
  - [2.5 桥接模式](#25-桥接模式)
  - [2.6 共享元模式](#26-共享元模式)
- [3. 行为模式](#3-行为模式)
  - [3.1 观察者模式](#31-观察者模式)
  - [3.2 命令模式](#32-命令模式)
  - [3.3 模板方法模式](#33-模板方法模式)
    - [模板模式优点](#模板模式优点)
    - [模板模式缺点](#模板模式缺点)
  - [3.4 策略模式](#34-策略模式)
  - [3.5 解释器模式](#35-解释器模式)
  - [3.6 访问者模式](#36-访问者模式)
  - [3.7 状态模式](#37-状态模式)

# 1. 创建模式

## 1.1 单例模式

**提供了一种创建对象的最佳方法，一般使用饿汉式**

**保证一个类只有一个实例，并提供一个访问它的全局访问点(自己创建唯一的实例并给其他对象提供这个实例，其他对象不需要实例化该类对象就可以访问)。**

```java
/**
 * 饿汉式(线程安全)
 * 优点：没有加锁，执行效率高
 * 缺点：类加载时就创建类，浪费内存；容易产生垃圾对象；
 * (常用)
 */
public class Singleton1 {
    private static Singleton1 instance = new Singleton1();
    private Singleton1() {
    }
    public static Singleton1 getInstance() {
        return instance;
    }
}
```

```java
/**
 * 懒汉式（线程安全）
 * 优点：需要时才创建，避免内存浪费
 * 缺点：加锁影响效率
 * (不常用)
 */
public class Singleton2 {
    private static Singleton2 instance = null;
    private Singleton2() {
    }
    public static synchronized Singleton2 getInstance() {
        if (instance  null) {
            instance = new Singleton2();
        }
        return instance;
    }
}
```

```java
/**
 * DCL+懒汉式（线程安全）
 * 优点：采用双重检验锁，多线程安全且高性能
 * 缺点：new Singleton()方法不是原子性的，因此当instance对象刚开辟一个新的内存空间的时候(不为null但是还没创建对象)，其他线程会返回一个空对象.
 * 解决方法：加上volatile关键字，及时同步共享变量。
 */
public class Singleton3 {
    private volatile static Singleton3 instance = null;
    private Singleton3() {
    }
    public static Singleton3 getInstance() {
        if (instance  null) {
            synchronized (Singleton3.class) {
                if (instance  null) {
                    instance = new Singleton3();
                }
            }
        }
        return instance;
    }
}
```

```java
/**
 * 枚举（线程安全）
 * 优点：真正的单例模式，不会被反射破坏
 */
public class Singleton4 {
  
    private Singleton4() {
    }
  
    static enum EnumTest {
        //创建一个枚举对象，该对象天生单例
        INSTANCE;
        private Singleton4 singleton4;

        private EnumTest() {
            singleton4 = new Singleton4();
        }

        public Singleton4 getInstance() {
            return singleton4;
        }
    }

		//对外暴露一个getInstance的方法
    public static Singleton4 getInstance(){
        return EnumTest.INSTANCE.getInstance();
    }
}
```

```java
package SingletonTest;
/**
 * 枚举（线程安全）（最终版本，直接用枚举类天生单例）
 * 优点：真正的单例模式，不会被反射破坏
 */
public enum Singleton4 {

    INSTANCE;

    public void doSomething(){
        System.out.println("do something");
    }

}

class Main{
    public static void main(String[] args) {
        Singleton4.INSTANCE.doSomething();
    }
}
```

## 1.2 工厂模式

**我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。**

**个人理解：工厂模式就是将类的实例化延迟到子类。**在创建对象前封装了一个工厂类，对用户隐藏创建逻辑，用户通过一个共同的接口获得想要的对象。

> https://www.runoob.com/design-pattern/factory-pattern.html

**意图：**定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。

**主要解决：**主要解决接口选择的问题。

**何时使用：**我们明确地计划不同条件下创建不同实例时。

**如何解决：**让其子类实现工厂接口，返回的也是一个抽象的产品。

**关键代码：**创建过程在其子类执行。

**应用实例：** 1、您需要一辆汽车，可以直接从工厂里面提货，而不用去管这辆汽车是怎么做出来的，以及这个汽车里面的具体实现。 2、Hibernate 换数据库只需换方言和驱动就可以。

**优点：** 1、一个调用者想创建一个对象，只要知道其名称就可以了。 2、扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。 3、屏蔽产品的具体实现，调用者只关心产品的接口。

**缺点：**每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。

**使用场景：** 1、日志记录器：记录可能记录到本地硬盘、系统事件、远程服务器等，用户可以选择记录日志到什么地方。 2、数据库访问，当用户不知道最后系统采用哪一类数据库，以及数据库可能有变化时。 3、设计一个连接服务器的框架，需要三个协议，"POP3"、"IMAP"、"HTTP"，可以把这三个作为产品类，共同实现一个接口。

**注意事项：**作为一种创建类模式，在任何需要生成复杂对象的地方，都可以使用工厂方法模式。有一点需要注意的地方就是复杂对象适合使用工厂模式，而简单对象，特别是只需要通过 new 就可以完成创建的对象，无需使用工厂模式。如果使用工厂模式，就需要引入一个工厂类，会增加系统的复杂度。

> 我们将创建一个 *Shape* 接口和实现 *Shape* 接口的实体类。下一步是定义工厂类 *ShapeFactory*。
>
> *FactoryPatternDemo* 类使用 *ShapeFactory* 来获取 *Shape* 对象。它将向 *ShapeFactory* 传递信息（*CIRCLE / RECTANGLE / SQUARE*），以便获取它所需对象的类型。

![image-20220207234632538](Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/image-20220207234632538-4248793.png)

```java
public interface Shape {

    void draw();
}

public class Circle extends EasyFactory implements Shape{

    @Override
    public void draw() {
        System.out.println("This is a Circle shape!");
    }
}

public class Rectangle extends EasyFactory implements Shape{

    @Override
    public void draw() {
        System.out.println("This is a Rectangle shape!");
    }
}

public class Square extends EasyFactory implements Shape{

    @Override
    public void draw() {
        System.out.println("This is a Square shape!");
    }
}

public class EasyFactory {

    public Shape getShape(String name) {
        if (name  null) {
            return null;
        }
        switch (name) {
            case "Rectangle":
                return new Rectangle();
            case "Circle":
                return new Circle();
            case "Square":
                return new Square();
        }
        return null;
    }
}

public class EasyFactoryDemo {
    public static void main(String[] args) {
        EasyFactory factory = new EasyFactory();
        Shape circle = factory.getShape("Circle");
        circle.draw();
        Shape rectangle =  factory.getShape("Rectangle");
        rectangle.draw();
        Shape square =  factory.getShape("Square");
        square.draw();
    }
}
```

## 1.3 抽象工厂模式

## 1.4 建造者模式

**[应用场景参考](https://blog.csdn.net/weixin_40841731/article/details/84852508)**

<img src="Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/image-20220327222524203.png" alt="image-20220327222524203" style="zoom:80%;" />

**是什么？**

建造者模式**将一个复杂对象的构建和它的表示分离，使得同样的构建过程可以构建不同的表示；**

**主要作用**

在用户**不了解**对象的构造过程细节的**情况下**，**可以直接创建复杂对象**。

```java
package BuilderPattern;

public class Test {

    public static void main(String[] args) {
        // 指挥Dirctor
        Director director = new Director();
        // 指挥 具体的工人Builder(implement interface) 完成产品(Product{meal,beverage,sncak,fruit})
        Product product = director.build(new Builder(),"板烧鸡腿堡","可乐去冰","甜筒*2","苹果");
        System.out.println("product = " + product);

        Product product1 = director.build(new Builder(),"麦辣鸡腿堡","雪碧","无","梨子");
        System.out.println("product1 = " + product1);
    }
}
/** 传入不同的参数，得到用户指定的不同对象
 * do 板烧鸡腿堡
 * do 可乐去冰
 * do 甜筒*2
 * do 苹果
 * product = Product{buildA='板烧鸡腿堡', buildB='可乐去冰', buildC='甜筒*2', buildD='苹果'}
 * do 麦辣鸡腿堡
 * do 雪碧
 * do 无
 * do 梨子
 * product1 = Product{buildA='麦辣鸡腿堡', buildB='雪碧', buildC='无', buildD='梨子'}
 */
```

**例子理解**

**比如一个游戏的地图渲染，用户可以通过调整几个参数（例如：分辨率高/中/低；是否需要展示血条；是否需要加载音乐……）来控制不同的对象创建。理解为用户可以控制选择对象的一些属性。**

> 用户**只需要传入我要的东西**，建造者模式的创建方式可以**直接返回你要的东西的对象**。
>
> **比如：**你要去麦当劳，主食：板烧鸡腿堡🍔；饮料：可乐🥤；小食：薯条🍟；
>
> 你也可以，主食：麦辣鸡腿堡🍔；饮料：七喜；小食：鸡块；
>
> 这些过程中，用户只需要传入这几个参数即可获得最后的套餐对象；

**优点✅**

1. 产品的**建造和表示分离，实现解耦**。使用建造者模式可以使客户端不必知道产品内部组成的细节。

   **理解：**类似于调用一个接口方法，然后不用关心底层具体实现，只知道这个方法最后会返回给我结果。

2. 将复杂产品的创建步骤分解到不同的方法中，使得创建过程更加清晰；

   **理解：**可以把一些复杂的逻辑，拆分开，可能本来`提交订单`把减少商品库存、计算优惠方式、日志记录等等都写在一起，耦合度高且不易复用。通过该方式，将他们提取出3个通用步骤，提高代码的复用率。

3. 具体的**建造者类(Builder)是相互独立的，这有利于系统的扩展。**增加新的具体建造者，无需修改原有类库的代码，符合“开闭原则”。

   **理解：**新增新的接口，不影响原来的接口使用。并且可以复用一些通用步骤。例如计算优惠方式可能还会单独使用来`获取优惠金额`.

**缺点❌**

1. 如果**所创建的产品或者说所做的业务逻辑共同点不多**的话，会导致需要创建过多的builder类，**导致系统很庞大**。



## 1.5 原型模式

# 2. 结构模式

## 2.1 适配器模式

## 2.2 代理模式

参考资料：**[cn-blogs动态代理和Cglib区别](https://www.cnblogs.com/sandaman2019/p/12636727.html)**

**是什么？**

*代理类*作为被代理类的访问层**实现所有被代理类功能并做一些控制（添加权限、访问控制）**，用户访问*代理类*即可。

**各种代理模式适用场景：**如果**目标对象实现接口**，用**动态代理**，如果目标对象没有实现接口，用**Cglib；**

**动态代理核心代码**

```java
//核心方法
@CallerSensitive 获取代理对象所需要的参数
public static Object newProxyInstance(ClassLoader loader,//目标对象Target的类加载器
                                      Class<?>[] interfaces,//目标对象Target的接口类
                                      InvocationHandler h) {}//（调用）事件处理器，当执行目标对象方法的时候，会触发时间处理器的方法，把当前执行的																																target对象的方法作为参数传入

//Demo代码
System.out.println("= 方法二 =");
        AdminService target = new AdminServiceImpl();//一个目标对象

        AdminService proxy2 = (AdminService) Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), new InvocationHandler() {//一个事件处理器对象
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                System.out.println("----------------------------------------");
                System.out.println("[LOG] START TIME:" + new Date());
                System.out.println("判断用户是否有权限进行操作");
                Object obj = method.invoke(target);
                System.out.println("记录用户信息、操作信息、更改内容、时间");
                System.out.println("[LOG] END TIME:" + new Date());
                return obj;
            }
        });//即可实现动态代理

        Object obj2 = proxy2.search();
        System.out.println("search()返回的对象：" + obj2.getClass());
        proxy2.update();
```



**意图：**为其他对象提供一种代理以控制对这个对象的访问。

**主要解决：**在直接访问对象时带来的问题，比如说：要访问的对象在远程的机器上。在面向对象系统中，有些对象由于某些原因（比如对象创建开销很大，或者某些操作需要安全控制，或者需要进程外的访问），直接访问会给使用者或者系统结构带来很多麻烦，我们可以在访问此对象时加上一个对此对象的访问层。

**何时使用：**想在访问一个类时做一些控制。

**如何解决：增加中间层。**

**关键代码：**实现与被代理类组合。

**应用实例：** 1、Windows 里面的快捷方式。 2、猪八戒去找高翠兰结果是孙悟空变的，可以这样理解：把高翠兰的外貌抽象出来，高翠兰本人和孙悟空都实现了这个接口，猪八戒访问高翠兰的时候看不出来这个是孙悟空，所以说孙悟空是高翠兰代理类。 3、买火车票不一定在火车站买，也可以去代售点。 4、一张支票或银行存单是账户中资金的代理。支票在市场交易中用来代替现金，并提供对签发人账号上资金的控制。 5、spring aop。

**优点：** 1、职责清晰。 2、高扩展性。 3、智能化。

**缺点：** 1、由于在客户端和真实主题之间增加了代理对象，因此有些类型的代理模式可能会造成请求的处理速度变慢。 2、实现代理模式需要额外的工作，有些代理模式的实现非常复杂。

**使用场景：**按职责来划分，通常有以下使用场景： 1、远程代理。 2、虚拟代理。 3、Copy-on-Write 代理。 4、保护（Protect or Access）代理。 5、Cache代理。 6、防火墙（Firewall）代理。 7、同步化（Synchronization）代理。 8、智能引用（Smart Reference）代理。

**动态代理在Java中有着广泛的应用，比如Spring AOP、Hibernate数据查询、测试框架的后端mock、RPC远程调用、Java注解对象获取、日志、用户鉴权、全局性异常处理、性能监控，甚至事务处理等。**

**注意事项：** 1、和**适配器模式**的区别：适配器模式主要改变所考虑对象的接口，而代理模式不能改变所代理类的接口。 2、和**装饰器模式**的区别：装饰器模式为了增强功能，而代理模式是为了加以控制。

### 静态代理

**在不改变目标对象的情况下，实现了对目标对象的功能扩展。**

**不足：静态代理实现了目标对象的所有方法，一旦目标接口增加方法，代理对象和目标对象都要进行对应的修改，维护成本增大。**

**<img src="Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/image-20220208122310711.png" alt="image-20220208122310711"  />**

### 动态代理

为解决静态代理对象必须实现接口的所有方法，Java使用动态代理。

1. **Proxy对象不需要implement 接口**
2. **Proxy对象的生成利用JDK的API，在JVM内存中动态的构建Proxy对象。用到java.lang.reflect.Proxy类**

#### DynamicProxy

```java
package ProxyTest.Dynamic;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;

public class AdminServiceDynamicProxy {
    private Object target;
    private InvocationHandler invocationHandler;

    public AdminServiceDynamicProxy(Object target, InvocationHandler invocationHandler) {
        this.target = target;
        this.invocationHandler = invocationHandler;
    }

    public Object getPersonProxy(){
        Object obj = Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), invocationHandler);//核心代码获取代理对象
        return obj;
    }
}
```

```java
@CallerSensitive 获取代理对象所需要的参数
public static Object newProxyInstance(ClassLoader loader,//目标对象的类加载器
                                      Class<?>[] interfaces,//目标对象实现的接口类
                                      InvocationHandler h) {}//（调用）事件处理器，当执行目标对象方法的时候，会触发时间处理器的方法，把当前执行的target对象的方法作为参数传入
```

#### InvocationHandler

```java
package ProxyTest.Dynamic;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.Date;

public class AdminServiceInvocation implements InvocationHandler {

    private Object target;

    public AdminServiceInvocation(Object target) {
        this.target = target;
    }

  /**
   * 当代理实例执行目标对象的方法的时候，会触发invoke方法，并进入。
   */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("----------------------------------------");
        System.out.println("[LOG] START TIME:" + new Date());
        System.out.println("判断用户是否有权限进行操作");
        Object obj = method.invoke(target);//method会带着方法名进来，target是目标对象，从而定位到具体方法
        System.out.println("记录用户信息、操作信息、更改内容、时间");
        System.out.println("[LOG] END TIME:" + new Date());
        return obj;
    }
}
```

#### DemoTest

```java
package ProxyTest.Dynamic;

public class Demo {
    public static void main(String[] args) {
        //方法一
        System.out.println("= 方法一 =");
        AdminService adminService = new AdminServiceImpl();
        System.out.println("代理的目标对象：" + adminService.getClass());//获取被代理类对象

        AdminServiceInvocation adminServiceInvocation = new AdminServiceInvocation(adminService);//创建事件处理器对象
        AdminService proxy 
          = (AdminService) new AdminServiceDynamicProxy(adminService, adminServiceInvocation).getPersonProxy();//获取代理对象
        System.out.println("代理的对象：" + proxy.getClass());

        Object obj = proxy.search();
        System.out.println("search()返回的对象：" + obj.getClass());
        proxy.update();
        System.out.println();

        //方法二
        System.out.println("= 方法二 =");
        AdminService target = new AdminServiceImpl();//一个目标对象

        AdminService proxy2 = (AdminService) Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), new InvocationHandler() {//一个事件处理器对象
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                System.out.println("----------------------------------------");
                System.out.println("[LOG] START TIME:" + new Date());
                System.out.println("判断用户是否有权限进行操作");
                Object obj = method.invoke(target);
                System.out.println("记录用户信息、操作信息、更改内容、时间");
                System.out.println("[LOG] END TIME:" + new Date());
                return obj;
            }
        });//即可实现动态代理

        Object obj2 = proxy2.search();
        System.out.println("search()返回的对象：" + obj2.getClass());
        proxy2.update();
    }
}
```

```mark
输出结果:
= 方法一 =
代理的目标对象：class ProxyTest.Dynamic.AdminServiceImpl
代理的对象：class jdk.proxy1.$Proxy0
----------------------------------------
[LOG] START TIME:Tue Feb 08 13:20:22 CST 2022
判断用户是否有权限进行操作
系统正在执行数据库查询操作
记录用户信息、操作信息、更改内容、时间
[LOG] END TIME:Tue Feb 08 13:20:41 CST 2022
search()返回的对象：class java.lang.Object
----------------------------------------
[LOG] START TIME:Tue Feb 08 13:20:49 CST 2022
判断用户是否有权限进行操作
系统正在执行修改操作
记录用户信息、操作信息、更改内容、时间
[LOG] END TIME:Tue Feb 08 13:20:50 CST 2022

= 方法二 =
----------------------------------------
[LOG] START TIME:Tue Feb 08 13:32:11 CST 2022
判断用户是否有权限进行操作
系统正在执行数据库查询操作
记录用户信息、操作信息、更改内容、时间
[LOG] END TIME:Tue Feb 08 13:32:11 CST 2022
search()返回的对象：class java.lang.Object
----------------------------------------
[LOG] START TIME:Tue Feb 08 13:32:11 CST 2022
判断用户是否有权限进行操作
系统正在执行修改操作
记录用户信息、操作信息、更改内容、时间
[LOG] END TIME:Tue Feb 08 13:32:11 CST 2022
```

### Cglib代理(Code Generation Library)

JDK动态代理要求target对象是一个接口的实现类，**如果target对象只是一个单独的对象，没有实现任何的接口，就需要用到Cglib代理**，即**通过构建一个子类对象，从而实现对target对象的代理**，因此**目标对象不能是final类(报错)**，且**目标对象的方法不能是final或static(不执行代理功能)**。

```java
package ProxyTest.Cglib;

import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

import java.lang.reflect.Method;

/**
 * 代理类
 */
public class AdminCglibServiceProxy implements MethodInterceptor {

    private Object target;

    public AdminCglibServiceProxy(Object target) {
        this.target = target;
    }

    //给目标对象创建一个代理对象 (核心代码)
    public Object getProxyInstance() {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(target.getClass());//设置该代理类的父类为目标对象
        enhancer.setCallback(this);//设置回调函数为该代理类
        return enhancer.create();//创建子类代理对象
    }

    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        System.out.println("判断用户是否有权限进行操作");
        Object obj = method.invoke(target);
        System.out.println("记录用户执行操作的用户信息、更改内容和时间等");
        return obj;
    }
}
```

```java
package ProxyTest.Cglib;

/**
 * 目标对象类
 */
public class AdminCglibService {
    public void update() {
        System.out.println("修改数据库信息");
    }

    public Object search() {
        System.out.println("查询数据库信息");
        return new Object();
    }
}
```

```java
package ProxyTest.Cglib;

/**
 * Cglib测试类
 */
public class Demo {
    public static void main(String[] args) {
        AdminCglibService target = new AdminCglibService();
        AdminCglibServiceProxy proxyFactory = new AdminCglibServiceProxy(target);
        AdminCglibService proxy = (AdminCglibService) proxyFactory.getProxyInstance();

        System.out.println("代理对象：：" + proxy.getClass());

        Object obj = proxy.search();
        System.out.println("search返回对象：" + obj.getClass());
        proxy.update();
    }
}
```



## 2.3 组合模式

## 2.4 装饰器模式

## 2.5 桥接模式

## 2.6 共享元模式

# 3. 行为模式

![image-20220208223315064](Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/image-20220208223315064-4330796.png)

## 3.1 观察者模式

当对象存在一对多关系时，使用观察者模式。比如，**当一个对象被修改时，则会通知依赖它的对象。**

**关键代码：**在抽象类里有一个ArrayList存放观察者们。

**应用实例：**当一个商品价格发生变动的时候，就会通知关注这个店铺或者商品的顾客。

**优点：**

1. 观察者和被观察者是抽象耦合的；

2. 建立一套触发机制；

**缺点：**

1. 如果一个被观察者对象**有很多观察者的话，全部通知会花费很多时间**；
1. 如果出现观察者和被观察者之间**循环依赖，导致系统崩溃**；
1. 观察者不知道被观察者**这么发生变化的，仅仅知道发生了变化**；

**注意事项⚠️：**

1. **避免循环引用**♻️
2. 如果顺序执行，某一个观察者出错会导致系统卡壳，一般采用**异步方式**。

![截屏2022-02-07 下午5.45.54](Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/%E6%88%AA%E5%B1%8F2022-02-07%20%E4%B8%8B%E5%8D%885.45.54-4242555.png)

## 3.2 命令模式

**解耦发送者和接收者，在两者之间加入一个中间者，发送者不再需要知道接收者的任何接口，只和中间者打交道。**对行为进行了封装

![image-20220208190307313](Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/image-20220208190307313-4318188.png)

## 3.3 模板方法模式

用抽象类定义一个大的模板骨架**（用`final`修饰）**和方法，抽象通用方法，其他的步骤在子类实现。

**父类模版方法定义不变的流程，子类重写流程中的方法**

```java
public abstract class AbstractClass {
    // 共同的且繁琐的操作
    private void baseOperation() {
        // do something
    }

    // 由子类定制的操作
    protected abstract void customOperation();

    // 模板方法定义的框架
    public final void templateMethod() {
        /**
         * 调用基本方法，完成固定逻辑
         */
        baseOperation();
        customOperation();
    }
}

//ConcreteClass1.java
public class ConcreteClass1 extends AbstractClass{

    @Override
    protected void customOperation() {
        // 具体模板1 业务逻辑
        System.out.println("具体模板1：customOperation()");
    }
}

//ConcreteClass2.java
public class ConcreteClass2 extends AbstractClass{
    @Override
    protected void customOperation() {
        // 具体模板2 业务逻辑
        System.out.println("具体模板2：customOperation()");
    }
}
```

### 模板模式优点

①、封装不变部分， 扩展可变部分

把认为是不变部分的算法封装到父类实现， 而可变部分的则可以通过继承来继续扩展。

②、提取公共部分代码， 便于维护

③、行为由父类控制， 子类实现

基本方法是由子类实现的， 因此子类可以通过扩展的方式增加相应的功能， 符合开闭原则。

### 模板模式缺点

①、子类执行的结果影响了父类的结果，这和我们平时设计习惯颠倒了，在复杂项目中，会带来阅读上的难度。

②、可能引起子类泛滥和为了继承而继承的问题 

> **为了解决上述缺点，可以使用回调函数Callback代替子类继承**

```java
public interface Callback {
    void customOperation();
}
public class SubCallback implements Callback{
    @Override
    public void customOperation() {
        System.out.println("SubCallback customOperation");
    }
}
/**
 * 模板类
 * 声明为 final，无法被继承,防止恶意修改
 */
public final class Template {
    private void baseOperation(){
        System.out.println("模板类公共操作");
    }

    public void templateMethod(Callback callback){
        baseOperation();
        callback.customOperation();
    }
}
```

Template是一个稳定的final类，无法被继承，不存在子类行为影响父类结果的问题，而Callback是一个接口，为了继承而继承的问题消失了。

## 3.4 策略模式

**定义一系列的相似的算法或者业务逻辑,把它们一个个封装起来, 并且使它们可相互替换，避免多重条件多个if…else…判断。**

当有很多if…else…的多重判断，且每个里面的运行条件复杂的时候，我们就需要使用策略模式。

**使用场景：**

当我付款的时候有多种优惠策略：***新用户-10元/ 满减200 -15元/ 打折券 打9折***……那我们在付款过程就需要使用策略模式。不过需要暴露所有的策略类。

![image-20220208182335550](Java%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F.assets/image-20220208182335550-4315816.png)

## 3.5 解释器模式

## 3.6 访问者模式

## 3.7 状态模式