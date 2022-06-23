# JUC笔记📒



[JDK1.8 API文档](https://docs.oracle.com/javase/8/docs/api/)

**主要学习的API**

![image-20220303091915289](JUC%E7%AC%94%E8%AE%B0.assets/image-20220303091915289.png)

---



## Semaphore

### 是什么？

> A counting semaphore. Conceptually, a semaphore maintains a set of permits.
>
> **一个计数信号量，维护一组许可证。**
>
> Each [`acquire()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html#acquire--) blocks if necessary until a permit is available, and then takes it.
>
> **每个acquire()方法会阻塞等待许可可用，然后获取它。**
>
> Each [`release()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Semaphore.html#release--) adds a permit, potentially releasing a blocking acquirer.*
>
> **每个release()方法会增加一个许可，释放阻塞资源。**
>
> However, no actual permit objects are used; the `Semaphore` just keeps a count of the number available and acts accordingly.
>
> **Semaphore只是在维持一个计数器并执行对应操作，并没有真实的许可证对象！**

![image-20220303151003805](JUC%E7%AC%94%E8%AE%B0.assets/image-20220303151003805.png)

### 用在哪？场景

> **Semaphores are often used to ==restrict the number of threads== than can access some (physical or logical) resource. **
>
> **JDK1.8中我们看到，它的作用就是用来限制访问共享资源的线程数量，也就是==限流==！**



### 怎么用？

#### 构造方法

![image-20220303095903966](JUC%E7%AC%94%E8%AE%B0.assets/image-20220303095903966.png) 

>  ==**拓展**==：这里用到了**==工厂模式==**.
>
> 内部类**==FairSync==**和**==NonfairSync==**都继承Sync类。根据fair来动态选择创建的实例对象。**默认是非公平**
>
> 他们的**==主要区别==**：就是线程是否是FIFO



#### 主要方法

![image-20220303101409663](JUC%E7%AC%94%E8%AE%B0.assets/image-20220303101409663.png) 



#### accquire()

```java
public class SemaphoreTest {
    public static void main(String[] args) {
        Semaphore available2 = new Semaphore(5);
        System.out.println("当前可用包间：" + available2.availablePermits());
        System.out.println();

        for (int i = 1; i <= 6; i++) {
          final int idx = i;
          new Thread(() -> {
            try {
              available2.acquire(); // 阻塞等待
              System.out.println(Thread.currentThread().getName() + "正在上厕所……");
              TimeUnit.SECONDS.sleep(2); // 上了2s的厕所

            } catch (InterruptedException e) {
              e.printStackTrace();
            } finally {
              System.out.println(Thread.currentThread().getName() + "上完厕所！");
              available2.release();
            }
          }, String.valueOf(i)).start();
        }
    }
}
```

```bash
# 输出：
当前可用包间：5

1正在上厕所……
2正在上厕所……
3正在上厕所……
4正在上厕所……
5正在上厕所……
2上完厕所！
1上完厕所！
5上完厕所！
4上完厕所！
3上完厕所！
6正在上厕所……
6上完厕所！
```



## CyclicBarrier

### 是什么？

> **A synchronization aid that allows a set of threads to all wait for each other to reach a common barrier point.**
>
> **是一种同步方法，==允许一组线程相互等待一起到达一个屏障点==**

> **A `CyclicBarrier` supports an optional [`Runnable`](https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html) command that is run once per barrier point, after the last thread in the party arrives, but before any threads are released. This *barrier action* is useful for updating shared-state before any of the parties continue.**
>
> **当所有的线程都到达，并且所有的线程还没释放之前，可以允许执行一个Runnable命令**



### 用在哪？场景

**在线拼团**

```java
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.TimeUnit;

public class CyclicBarrierTest {

    static List<String> list = new ArrayList<>();
    static Map<String, CyclicBarrier> map = new HashMap<>();

    public static void main(String[] args) throws InterruptedException {
        for (int i = 0; i < 6; i++) {
            TimeUnit.SECONDS.sleep(1);
            new CyclicBarrierTest().addBuyTogether(String.valueOf(i), "2", 3);
        }
    }

    private void addBuyTogether(String uid, String pid, int parties) {

        if (list.isEmpty() || !list.contains(pid)) {
            list.add(pid);
            map.put(pid, new CyclicBarrier(parties, () -> {
                System.out.println(parties + "人拼团任务已经完成！订单提交！");
            }));
        }

        CyclicBarrier barrier = map.get(pid);
        new Thread(() -> {
            System.out.println("用户"+Thread.currentThread().getName() + "加入了购买商品" + pid + "的拼团！");
            System.out.println("当前等待人数：" + (barrier.getNumberWaiting()+1) + "/" + parties);
            try {
                barrier.await();
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (BrokenBarrierException e) {
                e.printStackTrace();
            }
        }, uid).start();

    }
}
```

<img src="%E9%A1%B9%E7%9B%AE%E6%95%B4%E7%90%86.assets/image-20220304170830289.png" alt="image-20220304170830289" style="zoom:40%;" /> 



### 怎么用？

**API 方法介绍**

| 返回类型  | 方法名称和描述                                               | 中文解释                                 |
| --------- | ------------------------------------------------------------ | ---------------------------------------- |
| `int`     | `await()`Waits until all [parties](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CyclicBarrier.html#getParties--) have invoked `await` on this barrier. | 阻塞等待其他线程到达                     |
| `int`     | `await(long timeout, TimeUnit unit)`Waits until all [parties](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CyclicBarrier.html#getParties--) have invoked `await` on this barrier, or the specified waiting time elapses. | 阻塞等待其他线程到达，或者设定的时间到达 |
| `int`     | `getNumberWaiting()`Returns the number of parties currently waiting at the barrier. | 获得当前到达屏障点的线程数量             |
| `int`     | `getParties()`Returns the number of parties required to trip this barrier. | 获取屏障点要求到达的线程数量             |
| `boolean` | `isBroken()`Queries if this barrier is in a broken state.    | 查询是否当前屏障状态是broken             |
| `void`    | `reset()`Resets the barrier to its initial state.            | 重置初始化屏障状态                       |

**测试**

```java
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.TimeUnit;

public class CyclicBarrierTest {

    public static void main(String[] args) {
        CyclicBarrier barrier = new CyclicBarrier(7, () -> {
            System.out.println("所有任务已完成，提交任务！");
        });
        for (int i = 0; i < 5; i++) {
            new Thread(() -> {
                try {
                    System.out.println(Thread.currentThread().getName() + "==>完成业务逻辑！");
//                    barrier.await();// 如果一直等不到屏障点要求的线程数量，就会一直阻塞在这里
                  
                    //为了避免上面的问题，我们可以加入一个等待时间，当超过了等待时间，就会报错！并释放所有线程！
                    barrier.await(2, TimeUnit.SECONDS);
                  
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }, String.valueOf(i + 1)).start();
        }
    }
}
```

<img src="JUC%E7%AC%94%E8%AE%B0.assets/image-20220304163712001.png" alt="image-20220304163712001" style="zoom:50%;" /> 



## CountDownLatch

减法计数器：当每调用一次`countDownLatch.countDown()`方法后，就会数量-1；当计数器归0之后，`countDownLatch.await()`就会被唤醒，继续执行！



**场景：**

王者荣耀等待进入游戏，感觉可以用这个方式来实现。当10个人都点击确认后，计数器归零。

然后进入到游戏





## AQS

**[参考链接🔗](https://blog.csdn.net/mulinsen77/article/details/84583716)**

### 是什么？

> **AQS就是基于CLH==队列==，用==volatile修饰共享变量state==，线程通过==CAS去改变状态符==，成功则获取锁成功，==失败则进入等待队列，等待被唤醒==**



> **什么是CLH队列？**

CLH（Craig，Landin，and Hagersten）队列是一个虚拟的双向队列，虚拟的双向队列即不存在队列实例，仅存在节点之间的关联关系。
**AQS是将==每一条请求共享资源的线程==封装成一个CLH锁队列的==一个结点==（Node），来实现锁的分配。**



### 用在哪？

实现了AQS的锁有：CAS、MutexLock、**ReadWriteLock、Condition、Semaphore、CyclicBarrier**都是AQS的衍生物

![image-20220305112900435](JUC%E7%AC%94%E8%AE%B0.assets/image-20220305112900435.png)

如图示，AQS维护了**一个volatile int state和一个FIFO线程等待队列**，多线程争用资源被阻塞的时候就会进入这个队列。state就是共享资源，其访问方式有如下三种：
**getState();**/ **setState();**/ **compareAndSetState();**

AQS 定义了**==两种资源共享方式==**：
1.**Exclusive**：独占，只有一个线程能执行，如**ReentrantLock**
2.**Share**：共享，多个线程可以同时执行，如**Semaphore、CountDownLatch、ReadWriteLock，CyclicBarrier**

不同的自定义的同步器争用共享资源的方式也不同。



### 原理

**==它为我们各种并发类提供了同步的模版！==**

- 如实现独占锁，如ReentrantLock需要自己实现**tryAcquire()方法、tryRelease()** 方法；
- 如实现共享模式的Semaphore，则需要实现**tryAcquireShared()方法、tryReleaseShared()** 方法；



> **AQS主要方法**

isHeldExclusively()：该线程是否正在独占资源。**只有用到condition**才需要去实现它。
**tryAcquire(int)：**独占方式。尝试获取资源，成功则返回true，失败则返回false。
**tryRelease(int)**：独占方式。尝试释放资源，成功则返回true，失败则返回false。
**tryAcquireShared(int)：**共享方式。尝试获取资源。负数表示失败；0表示成功，但没有剩余可用资源；正数表示成功，且有剩余资源。
**tryReleaseShared(int)：**共享方式。尝试释放资源，如果释放后允许唤醒后续等待结点返回true，否则返回false。



> **例子**

ReentrantLock为例，（可重入独占式锁）：**==state初始化为0==**，表示未锁定状态，**A线程lock()时，会调用tryAcquire()独占锁并将state+1.**之后其他线程再想tryAcquire的时候就会失败，**==直到A线程unlock（）到state=0为止==**，其他线程才有机会获取该锁。A释放锁之前，自己也是可以重复获取此锁（state累加），这就是可重入的概念。
注意：获取多少次锁就要释放多少次锁，保证state是能回到零态的。





## BlockingQueue（阻塞队列）

**原理：**就是一个会阻塞的队列FIFO

**写入：**如果队列满了，就必须阻塞等待

**读取：**如果队列空了，就必须阻塞等待

> **类家族**

![image-20220307091039216](JUC%E7%AC%94%E8%AE%B0.assets/image-20220307091039216.png)

<img src="JUC%E7%AC%94%E8%AE%B0.assets/image-20220307094940640.png" alt="image-20220307094940640" style="zoom:40%;" /> 



> **==四组BQ阻塞队列的API方法==**

参考自来自djk1.8的截图

|             | *Throws exception* | *Return Special value*    | *Blocks*         | *Times out*            |
| ----------- | ------------------ | ------------------------- | ---------------- | ---------------------- |
| **Insert**  | `add(e)`           | `offer(e)` return boolean | `put(e)`         | `offer(e, time, unit)` |
| **Remove**  | `remove()`         | `poll()` return null      | `take()`         | `poll(time, unit)`     |
| **Examine** | `element()`        | `peek()`                  | *not applicable* | *not applicable*       |

> **==SynchronousQueue同步队列==**

原理：

- 没有容量
- 进去一个元素，必须等待取出来之后，才能再往里面放一个元素！
- put() take()

```java
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.TimeUnit;

/**
 * 同步队列
 */
public class SynchronousQueueTest {
    public static void main(String[] args) {
        SynchronousQueue<String> synchronousQueue = new SynchronousQueue<>();

        // 生产者线程
        new Thread(() -> {
            try {
                System.out.println(Thread.currentThread().getName() + " put 1");
                synchronousQueue.put("1");
                System.out.println(Thread.currentThread().getName() + " put 2");
                synchronousQueue.put("2");
                System.out.println(Thread.currentThread().getName() + " put 3");
                synchronousQueue.put("3");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }, "T1").start();

        // 消费者线程
        new Thread(() -> {
            try {
                TimeUnit.SECONDS.sleep(3); // 休眠3s 来验证生产者线程会不会在1还没被消费的情况下，加入新的值。
                System.out.println(Thread.currentThread().getName() + " get " + synchronousQueue.take());
                TimeUnit.SECONDS.sleep(3);
                System.out.println(Thread.currentThread().getName() + " get " + synchronousQueue.take());
                TimeUnit.SECONDS.sleep(3);
                System.out.println(Thread.currentThread().getName() + " get " + synchronousQueue.take());
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }, "T2").start();

    }
}
```

![image-20220307094311201](JUC%E7%AC%94%E8%AE%B0.assets/image-20220307094311201.png) 









## Condition

用于线程间通信，可以精准唤醒。

<img src="JUC%E7%AC%94%E8%AE%B0.assets/image-20220307090616443.png" alt="image-20220307090616443" style="zoom:80%;" /> []()
