# MySQL数据库

- [MySQL数据库](#mysql数据库)
  - [数据库的数据结构](#数据库的数据结构)
    - [B树](#b树)
    - [B+树](#b树-1)
    - [**Hash索引**](#hash索引)
  - [数据库三大范式(update……)](#数据库三大范式update)
  - [优化方案(update……)](#优化方案update)
  - [窗口函数(update……)](#窗口函数update)
  - [MVCC](#mvcc)
    - [3个隐式字段](#3个隐式字段)
    - [undo log](#undo-log)
    - [Read View(读视图)](#read-view读视图)
  - [分库分表](#分库分表)
  - [主从同步原理](#主从同步原理)

## 数据库的数据结构

### B树

平衡多路查找树。非叶子节点既存了数据也存了指针，存储的指针量就比较少，因此深度就更高。

### B+树

B树基础上，叶子节点之间有指针连接，方便遍历。

- 1.一个节点有多个元素；

- 2.排序；

- 3.叶子节点之间是双向指针。

- -4.非叶子节点上只存储数据的指针，可以存储更多的指针，所以M叉分支的M可以更多，因此深度更浅，稳定。

- 5.所有数据存在叶子节点上

优点：很适合范围查询。

缺点：用自增主键作为主索引，否则维护成本高。

> 查看Innodb_page_size大小

![image-20220307224827228](MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/image-20220307224827228.png) 

一页的大小：16384/1024\=16KB

> **查看索引**

`show index from t1;`

> **查询语句的底层原理**

**接收select语句->一次I/O会取出来一页16KB->内存里再去取具体的行；**

> **存储结构**

![image-20220307232113156](MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/image-20220307232113156.png)





### **Hash索引**

单条记录查询、等值查询。根据keys做一次hash运算，根据得到的值就可以找到地址。无顺序。不支持联合索引（最左匹配原则）。

Hash碰撞：当计算出同一个hash值，指向同一个地址，然后遍历链表找到最终结果。













## 数据库三大范式(update……)

第一范式(确保每列保持**原子性**)；



第二范式(确保表中的每列都**和联合主键相关**)；



第三范式(确保每列都**和主键列直接相关**,而不是间接相关)；





参考资料：

[数据库三范式3NF指什么？](https://blog.csdn.net/DH2442897094/article/details/105656952)



## 优化方案(update……)





参考资料：

[MySQL慢查询优化、索引优化、表优化总结](https://mikechen.cc/3305.html)





## 窗口函数(update……)

<img src="MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/v2-12622c09cde05c02574c9f253b8b72e2_r.jpg" alt="preview" style="zoom:60%;" /> 

> Tips：

**SQL的执行顺序：**

–第一步：执行**FROM**

–第二步：**WHERE**条件过滤

–第三步：**GROUP BY**分组

–第四步：执行**SELECT**投影列

–第五步：**HAVING**条件过滤

–第六步：执行**ORDER BY** 排序



> 静态窗口函数

**排名函数**

应用场景：一般用来解决按照每组进行排名，并找出TOP N条数据。

<img src="MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/image-20220307173713095.png" alt="image-20220307173713095" style="zoom:50%;" /> 

> **场景：查找连续登录7天的用户**

1. 首先一个用户一天登录多次，需要先去重；`select distinct date from user_login;`
2. 用`row_number() over(partition by id) as ranking` 根据用户id分组
3. 用日期-计数值得到结果`date-ranking as result`
4. 统计result，`having count(*)>7`

```sql
 select res.device_id as id,count(ans)
 from 
 (select *, date-ranking as ans from 
	(select *,row_number() over (partition by device_id) as ranking 
		from (select distinct date, device_id from question_practice_detail) s ) a
	) res 
 group by res.device_id,res.ans
 having count(ans)>=3;
```



**参考资料：**

[通俗易懂的学会：SQL窗口函数](https://zhuanlan.zhihu.com/p/92654574)

[mysql连续登录5天以上用户,【SQL】查询连续登陆7天以上的用户](https://blog.csdn.net/weixin_36462094/article/details/116127835)



## MVCC

**Multiple Version Concurrent Control多版本并发控制**，目前只能在Innodb下(MyIsAM不支持事务)，只在RC和RR两个隔离级别下工作。

> **思考**

想想没有MVCC的情况下，我们如果对一行数据加了写锁，那么其他线程的无论读锁还是写锁都会被阻塞。在读多写少的场景下，有没有什么办法可以提高读的效率呢？

**因此它的目的，简单来说：在不加锁的情况下，解决读写冲突，做到非阻塞并发读(快照读)**。

> **它是如何做的呢？**

首先，需要了解几个东西：***3个隐式字段、undo日志、Read View***



### 3个隐式字段

- 三个隐式字段分别为：
  - **隐式主键：**如果数据库没有主键，会自动生成一个聚簇索引；
  - **事务ID：**记录这条记录最后一次修改该记录的事务ID；
  - **ROLL_PTR（回滚指针）：**配合undo日志，指向这条记录的上一个版本；**当前记录+undo日志的指针相连\>版本链**

<img src="MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/image-20220307141024322.png" alt="image-20220307141024322" style="zoom:25%;" /> 



### undo log

> **什么是undo日志呢？**

**记录数据被修改之前的日志**。就是当你修改之前，**先存一份**到undo日志中备份。

这么做是为了**当事务回滚**的时候，可以通过它进行**数据还原**。

> **undo日志有啥作用吗？**

1、保证事务rollback的原子性和一致性。对数据进行恢复；

2、用于MVCC快照读的数据，在MVCC中，通过读取undo log的历史版本数据可以实现不同事务版本号都拥有自己的独立快照数据版本。

> **undo日志的种类**

- Insert undo log

  代表事务insert新记录时产生的undo log，只在事务回滚时需要，并且在事务提交后立即丢弃；

- **update undo log（主要）**

  事务在进行update或者delete的时候产生的undo log；不仅在事务回滚时需要，**快照读**也需要；

  不会立即丢弃，而是**当快照读和事务回滚都不涉及**该历史版本数据的时候，才会被**purge线程统一清除**；



### Read View(读视图)

**[Read View理解🔗](https://www.cnblogs.com/axing-articles/p/11415763.html)**

事务对**快照读操作的那一刻的数据库系统生成一个当前快照**作为Read View；

**主要目的：可见性判断**

- 小于当前活跃事务的最小版本号 || 事务ID就是我自己=>显示

- 大于当前活跃事务的最大事务ID，说明是生成Read View之后才创建的=>不显示
- 小于当前活跃事务的最大事务ID && 不存在活跃事务中，表明事务已经commit，=>显示；
- 小于当前活跃事务的最大事务ID && 存在活跃事务中，表明事务还没commit，=>不显示；

> **可见性图解**

<img src="MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/image-20220307152640890.png" alt="image-20220307152640890" style="zoom:67%;" /> 

> **更新方式**

- **Read Committed**：每次快照读生成并获取最新的Read View；
- **Repatable Read**：同一个事务的第一个快照读创建Read View，**MVCC（处理读写冲突）+ 间隙锁（处理写写冲突）防止幻读**



> **当前读和快照读**

当前读：

```sql
select …… lock in share mode; #共享锁
select ...... for update  #排他锁
update #排他锁
insert #排他锁
delete #排他锁
```

快照读

```sql
select ... # 不加锁（前提是不是串行化级别的）
```



## 分库分表

> **什么是分库分表？**

主要包括**分库**和**分表**。

从拆分的角度上，分为**垂直分片**和**水平分片**。

**垂直分片：**从业务上来拆分。本来2个表在同一个数据库里，拆成一个表一个数据库。**缺点：无法解决一个表很大，查询慢的情况**

**水平分片：**将一个很大数据量的表，根据一些**分片策略**将数据分散到多个结构相同的表中。

**分片策略**

- 取余/取模：均匀存储；扩容麻烦，需要移动数据；
- 按照范围：好扩容；数据分布不均匀；
- 按照时间：容易出现热点数据在后几张表上。
- 按照枚举值：例如按照地区、按照类型；
- 按照目标字段前缀指定分区：自定义业务规则分片



*TIPS：阿里开发手册建议：当一个表的数据量超过500W或者数据文件超过2G，就要考虑分库分表；*

> **分表的查询原理**

**SQL解析-->查询优化-->SQL路由-->SQL改写-->SQL查询-->结果归并**

> **存在的问题**

- **事务一致性问题**：本来数据库的事务机制可以保证数据一致性。**[6种解决f方案🔗](https://zhuanlan.zhihu.com/p/183753774)**

- **跨节点关联查询问题**：本来可以关联查询。现在需要多次查询后，再进行拼装。

- **跨节点分页、排序函数**：本来可以直接排序和分页。现在需要排序后返回，合并结果集进行排序在分页。容易出现内存崩溃的问题。（可能需要用到外部排序）

- **主键避重问题**：原来可以用自增ID。现在需要专门设计全局主键。 

  解决方案：

  - UUID：简单、性能好、无序；

  - 数据库主键（起始值1 2，步长相同）**缺点：**拓展性很差，得提前规划好

  - redis、mongodb、zk中间件：增加系统的复杂度和稳定性

  - 雪花算法：**64bit（1bit-不用+41bit-时间戳+10bit工作机器id+12bit序列号）** **【[分布式ID神器——雪花算法🔗](https://zhuanlan.zhihu.com/p/85837641)】**

    ![img](MySQL%E6%95%B0%E6%8D%AE%E5%BA%93.assets/v2-0ca4a4125b1cbda69cfa972b1e568ffb_1440w.jpg) 

- **公共表维护**：例如数据字典基本都要被联合查询，需要每个数据库配一个。







## 主从同步原理

**目的是为了在分布式架构下，保持各节点数据一致性**

**主要有三个线程：master一条（binlog dump thread）、slave两条（I/O thread、SQL thread）。**

- 主节点**bin log会记录所有的**数据库**变更**的一个文件；
- 主节点log dump线程，**当bin log变动，log dump线程读取其内容并发送到从节点**；
- **从节点I/O线程接收bin log内容**，并将其写入到relay log文件中。
- 从节点的SQL线程读取relay log文件内容对数据更新进行重放，最终保证主从数据库的一致性。

**Note**：主从节点使用的binlog文件+position偏移量来定位主从同步的位置，增量同步！



**问题：MySQL默认复制的方式是异步的。当主库挂了或者从库处理失败了，日志就丢失了**

**解决方案：**

1. **全同步复制：**主库写入binlog后强制同步到从库，然后等待所有的从库执行完成后回给客户端；
2. **半同步复制：**相比全同步，只需要至少收到一个从库的确认就认为写操作完成了。
