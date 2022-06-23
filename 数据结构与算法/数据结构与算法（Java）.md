## 数据结构与算法（Java）

# 数据结构

## 二叉树

> 参考文章：
>
> [满二叉树、完全二叉树、二叉搜索树、平衡二叉树](https://zhuanlan.zhihu.com/p/106828968)

### 1、满二叉树

![img](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/v2-33552ea97a8ac99b55241bf7b33f2543_1440w.jpg) 



### 2、完全二叉树

**BFS层序遍历下来，不存在null节点，也可以理解为满二叉树从后往前删除后剩下的树**

![img](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/v2-5fd3c3dd465ad818ab12d8314b4ed346_1440w.jpg) 

### 3、二叉搜索树（二叉查找树）

**二叉搜索树中，左子树都比其根节点小，右子树都比其根节点大，递归定义**。

**查询效率：O($log_{2}n$)  最差情况就是退化成链表 O(n)**

![img](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/v2-fd895b764ad8c4e20bf8ab4492270bb4_1440w.jpg) 



### 4、平衡二叉搜索树BBST

- **提出是为了不出现二叉搜索树的极端情况，尽量保证平衡**

- **定义：平衡二叉树要么是一棵空树，要么保证左右子树的高度之差不大于 1，并且子树也必须是一棵平衡二叉树。**



#### AVL树（高度平衡树）

[参考链接🔗](https://blog.csdn.net/u014454538/article/details/120103527)

- **查找、插入、删除时间复杂度O(logn)**

**性质**

1. 可以是一棵**空树**
2. 左子树和右子树**高度之差的绝对值不超过1**（左右子树的高度差可以为0、1和 -1）
3. **左子树和右子树均为平衡二叉树**

**平衡因子**

- 定义中，**左子树和右子树高度之差被称作平衡因子**：左子树高度 - 右子树高度
- AVL树中，要求 a b s ( 平 衡 因 子 ) < = 1 abs(平衡因子) <= 1abs(平衡因子)<=1，即左右子树的高度差为0、1和 -1
- 以上数值分别表示：左子树与右子树等高、左子树比右子树高、左子树比右子树矮

**最小不平衡子树**

- 平衡二叉树，要求平衡因子 abs (平衡因子) < = 1
- 下图，新插入节点37，该树不再是平衡二叉树。因为，节点58的左右子树高度差为2

<img src="https://img-blog.csdnimg.cn/04ca14c77496471c965045961c1d09bd.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5pmT5LmL5pyo5Yid,size_20,color_FFFFFF,t_70,g_se,x_16" style="zoom:50%;" /> 

- 从新插入节点向上查找，第一个abs(平衡因子)>1的节点为根的子树，被称为最小不平衡子树
- 上图中，新插入节点向上查找，节点58左右子树高度差为2，**以节点58为根节点的子树，就是最小不平衡子树**

> **关于最小不平衡子树的说明**

1. 新插入节点，可能导致平衡二叉树出现多棵不平衡的子树
2. 此时，我们只需要调整最小不平衡子树，就能让整棵树平衡

**四种情况的描述**

LL：新插入节点为最小不平衡子树根节点的**左儿子的左子树上** →  右旋使其恢复平衡

RR：新插入节点为最小不平衡子树根节点的**右儿子的右子树上** →  左旋使其恢复平衡

LR：新插入节点为最小不平衡子树根节点的**左儿子的右子树上** → 以左儿子为根节点进行左旋，再按原始的根节点右旋

![](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5pmT5LmL5pyo5Yid,size_20,color_FFFFFF,t_70,g_se,x_16.png)

RL：新插入节点为最小不平衡子树根节点的**右儿子的左子树上** →  以右儿子为根节点进行右旋，再按原始的根节点左旋

![](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA5pmT5LmL5pyo5Yid,size_20,color_FFFFFF,t_70,g_se,x_16.jpeg)





#### **红黑树**

**也是一个平衡二叉树！**

- **根节点是黑色的；**
- **每个叶子节点都是黑色的空节点**（NIL），也就是说，叶子节点不存储数据；
- 任何**相邻的节点都不能同时为红色**，**红色节点是被黑色节点隔开的**；
- **每个节点，从该节点到达其可达叶子节点的所有路径，都包含相同数目的黑色节点**





### AVL树和红黑树区别

|                  | AVL树                                                        | 红黑树                                                       |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **严格平衡**     | 严格平衡树，因此在增加或者删除节点的时候，根据不同情况，旋转的次数比红黑树要多 | 非严格的平衡来换取**增删节点时候旋转次数的降低**，任何不平衡都会在**三次旋转之内解决** |
| **新增节点**     | O(1)，最多两次树旋转实现rebalance                            | O(1)，最多两次树旋转实现rebalance                            |
| **删除节点** | O(logN),从被删除节点到根节点路径上所有节点的平衡             | O(1)，最多旋转3次实现rebalance                               |
| **查询节点** | O(logN) 查询效率更高                                         | O(logN) 查询相较更慢                                         |
| **实际应用** | **适用于#（搜索）>>#（插入和删除）**                     | **其他时候，选择红黑树**                                     |



















# 算法

> 参考文章：
>
> https://zhuanlan.zhihu.com/p/36436699
>
> [八大排序算法总结与java实现](https://itimetraveler.github.io/2017/07/18/%E5%85%AB%E5%A4%A7%E6%8E%92%E5%BA%8F%E7%AE%97%E6%B3%95%E6%80%BB%E7%BB%93%E4%B8%8Ejava%E5%AE%9E%E7%8E%B0/#%E5%9B%9B%E3%80%81%E5%A0%86%E6%8E%92%E5%BA%8F%EF%BC%88Heap-Sort%EF%BC%89)



## 排序算法总结

![image-20220224084857402](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/image-20220224084857402.png)

![img](%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/0B319B38-B70E-4118-B897-74EFA7E368F9.png)

### 算法选择思路

<img src="%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%EF%BC%88Java%EF%BC%89.assets/image-20220224124016242.png" alt="image-20220224124016242" style="zoom:50%;" />

### 1. 快速排序

**时间复杂度**：平均时间复杂度O($nlog_{2}n$)，最坏的情况O( $n^2$).

**空间复杂度**：只需要一个元素的辅助空间。但是需要一个栈空间来实现递归，因此空间复杂度O($nlog_{2}n$)

**核心思想**：把基点数据pivot移动到正确的位置上。分区partition。

**快速排序（递归版本）**

```java
package com.yt.ordered;

public class TwoRoadQuickSort {

    public static void main(String[] args) {
        int[] arr = new int[]{12, 2, 1, 8, 5, 9, 56, 11, 52};
        quickSort(arr, 0, arr.length - 1);
        for (int a : arr
        ) {
            System.out.println(a);
        }
    }


    private static void quickSort(int[] arr, int leftidx, int rightidx) {
        if (leftidx >= rightidx) return;

        int left = leftidx;
        int right = rightidx;

        int pivot = arr[left];

        while (left < right) {
            while (left < right && arr[right] > pivot) {
                right--;
            }
            if (left < right) {
                arr[left++] = arr[right];
            }
            while (left < right && arr[left] < pivot) {
                left++;
            }
            if (left < right) {
                arr[right--] = arr[left];
            }
        }
        arr[left] = pivot;

        quickSort(arr, leftidx, left);
        quickSort(arr, left + 1, rightidx);
    }
}

```

**快速排序（迭代版本）**

```java
package com.yt.ordered;

import java.util.Stack;

public class IterativeQuickSort {

    public static void main(String[] args) {
        int[] arr = new int[]{5, 1, 1, 2, 0, 0};
        new IterativeQuickSort().quickSort(arr, 0, arr.length - 1);
        for (int a : arr
        ) {
            System.out.println(a);
        }
    }


    private void quickSort(int[] arr, int leftidx, int rightidx) {
        Stack<Integer> stack = new Stack<>();
        stack.push(leftidx);
        stack.push(rightidx);

        while (!stack.isEmpty()) {
            rightidx = stack.pop();
            leftidx = stack.pop();
            int l = leftidx;
            int r = rightidx;

            // 只要leftidx<rightidx，说明数组里还有至少2个元素需要排序
            while (leftidx < rightidx) {

                swap(arr, l, (int) (Math.random() * (r - l + 1)) + l);
                int pivot = arr[l];

                while (l < r) {
                    while (l < r && arr[r] > pivot) {
                        r--;
                    }
                    if (l < r) {
                        arr[l++] = arr[r];
                    }
                    while (l < r && arr[l] < pivot) {
                        l++;
                    }
                    if (l < r) {
                        arr[r--] = arr[l];
                    }
                }

                arr[l] = pivot;

              //当仅剩2个元素，则认为此时，排序完成！如果不加，会出现无限循环；
              /* 
               * 例子：
               * 当数组0，0，1，1，5，2，此时leftidx=4（即：arr[leftidx]=5)，rightidx=5（即：arr[rightidx]=2)
               * 交换后，leftidx=4，l=4，l+1=5，rightidx=5；
               */ 
                if(rightidx-leftidx<=1)break;

                stack.push(leftidx);
                stack.push(l);

                stack.push(l + 1);
                stack.push(rightidx);
                break;
            }
        }

        return;
    }

    private void swap(int[] arr, int i, int j) {
        int tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
}
```

**三路排序** 

时间复杂度和空间复杂度同上

**使用场景：** **多用于相等的数字很多的情况**，  将数据分为3个部分，大于等于和小于,  **一次固定一组等于pivot的数据**

```java
package com.yt.ordered;

public class ThirdRoadQuickSort {

    public static void main(String[] args) {
        Integer[] arr = new Integer[]{2, 1, 2, 3, 1, 1, 2, 3, 2,3,4,6,7,8,8,3,1,32,43,6,31,24,5,78,2, 1, 1, 2};
        sort(arr, 0, arr.length - 1);
        for (int a : arr
        ) {
            System.out.println(a);
        }
    }


    private static void sort(Comparable[] arr, int left, int right) {
        if (right - left <= 0) return;
				//定好一个pivot后，放到最左边； 
      	//Math.Random()：官方介绍取值范围在[0,1)
      	//(int)：可理解为Math.floor()向下取整！
        int pivot = (int) (Math.random() * (right - left + 1) + left);
        swap(arr, left, pivot);

        Comparable v = arr[left];// 
        int lt = left;//掌管 小于和等于的分界，它本身的位置是小于的值
        int gt = right + 1; //掌管 大于和等于的分界，它本身的位置存储大于的值
        int i = left + 1; // 遍历指针

        while (i < gt) {
            if (arr[i].compareTo(v) < 0) {
                swap(arr, i, lt + 1);
                lt++;
                i++;
            } else if (arr[i].compareTo(v) > 0) {
                swap(arr, i, gt - 1);
                gt--;
            } else {
                i++;
            }
        }

        swap(arr, left, lt);

        sort(arr, left, lt - 1);
        sort(arr, gt, right);
    }

    private static void swap(Comparable[] arr, int i, int j) {
        int tmp = (Integer) arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
}
```



### 2. 插入排序

**插入排序的原理：默认前面是排序好的。然后遍历数组，对每个数字进行向前比较，一直比到比自己小的为止。**

**应用场景：当近乎有序的情况下，遍历过程就是O(n)，几乎不需要往回遍历，都在对的位置上，只有个别数字需要朝前遍历。**

```java
package com.yt.ordered;

public class InsertionSort {

    public static void main(String[] args) {

        int[] arr = new int[]{5, 1, 1, 2, 0, 0};
        insertionSort(arr);
        for (int a : arr) {
            System.out.println(a);
        }
    }

    private static void insertionSort(int[] arr) {

        for (int i = 1; i < arr.length; i++) {
            int curr = arr[i];

            int j; // j：代表倒序遍历已排序数组；j+1：代表空位置
            /*
             *  若当前j指针还没到已排序数组最前头 
             *  且当前j指针数字大于即将排序的数字，将大数字往后放；
             *  Until 当前指针数字小于需排序数字，说明找到了需排序数字的位置在arr[j+1]；
             */
            for (j = i - 1; j >= 0 && arr[j] > curr; j--) {
                arr[j + 1] = arr[j];
            }
            arr[j + 1] = curr;

        }
    }
}
```



### 3. 归并排序

**时间复杂度：O($nlog_{2}n$)** ，稳定的

**空间复杂度：O(n)**  由于用到额外空间，所以**不是就地排序**

**核心思想：1、先分治 2、再合并**

```java
package com.yt.ordered;

public class MergeSort {

    public static void main(String[] args) {

        int[] arr = new int[]{13, 4, 5, 2, 65, 6};
        mergeSort(arr, 0, arr.length - 1, new int[arr.length]);
        for (int a : arr) {
            System.out.println(a);
        }
    }

    private static void mergeSort(int[] arr, int left, int right, int[] tmp) {

        if (left < right) {
            // 1. 先分解
            int mid = (left + right) / 2;
            mergeSort(arr, left, mid, tmp);
            mergeSort(arr, mid + 1, right, tmp);
            // 2. 再归并
            merge(arr, left, mid, right, tmp);
        }
    }

    private static void merge(int[] arr, int left, int mid, int right, int[] tmp) {
        int i = left;//左子数组的头元素
        int j = mid + 1;//右子数组的头元素
        int count = 0;

        //比较两个子数组的元素,合并到额外数组空间中
        while (i <= mid && j <= right) {
            if (arr[i] < arr[j]) {
                tmp[count++] = arr[i++];
            } else {
                tmp[count++] = arr[j++];
            }
        }

        // 如果左子数组还没走完，剩下的直接放
        while (i <= mid) {
            tmp[count++] = arr[i++];
        }

        // 如果右子数组还没走完，剩下的直接放
        while (j <= right) {
            tmp[count++] = arr[j++];
        }

        for (int k = left, s = 0; k <= right; k++) {
            arr[k] = tmp[s++];
        }
    }
}
```















## 算法类型

### 1. 滑动窗口

**判断我们可能需要上滑动窗口策略的方法**

- 这个问题的**输入是一些线性结构**：比如链表呀，数组啊，字符串啊之类的
- 让你去**求最长/最短子字符串或是某些特定的长度要求**

### 2. 双指针

- 一般来说，**数组或是链表是排好序的**，你得在里头**找一些组合**满足某种限制条件
- 这种组合可能是**一对数，三个数，或是一个子数组**

### 3. 快慢指针

- 问题需要**处理环上的问题**，比如环形链表和环形数组
- 当你**需要知道链表的长度或是某个特别位置的信息**的时候

### 4. 回溯算法

**场景使用：组合、切割、子集、排列、棋盘**

**关键点**

- 递归函数
- 参数返回值
- 确定终止条件
- 单层递归逻辑

**框架**

```java
void backtracking(Params... params){
  if(终止条件){
    	收集结果；
      return
  }
  for(集合元素){
    	处理节点
      递归函数
      回溯操作
  }
}
```

**相关题目**

> [参考链接🔗](https://leetcode-cn.com/problems/permutations/solution/hui-su-suan-fa-python-dai-ma-java-dai-ma-by-liweiw/)

> 题型一：排列、组合、子集相关问题
> 提示：这部分练习可以帮助我们熟悉「回溯算法」的一些概念和通用的解题思路。解题的步骤是：先画图，再编码。去思考可以剪枝的条件， 为什么有的时候用 used 数组，有的时候设置搜索起点 begin 变量，理解状态变量设计的想法。
>
> 46. 全排列（中等）
> 47. 全排列 II（中等）：思考为什么造成了重复，如何在搜索之前就判断这一支会产生重复；
> 39. 组合总和（中等）
> 40. 组合总和 II（中等）
> 77. 组合（中等）
> 78. 子集（中等）
> 90. 子集 II（中等）：剪枝技巧同 47 题、39 题、40 题；
> 60. 第 k 个排列（中等）：利用了剪枝的思想，减去了大量枝叶，直接来到需要的叶子结点；
> 93. 复原 IP 地址（中等）
> 题型二：Flood Fill
> 提示：Flood 是「洪水」的意思，Flood Fill 直译是「泛洪填充」的意思，体现了洪水能够从一点开始，迅速填满当前位置附近的地势低的区域。类似的应用还有：PS 软件中的「点一下把这一片区域的颜色都替换掉」，扫雷游戏「点一下打开一大片没有雷的区域」。
>
> 下面这几个问题，思想不难，但是初学的时候代码很不容易写对，并且也很难调试。我们的建议是多写几遍，忘记了就再写一次，参考规范的编写实现（设置 visited 数组，设置方向数组，抽取私有方法），把代码写对。
>
> 733. 图像渲染（Flood Fill，中等）
> 200. 岛屿数量（中等）
> 130. 被围绕的区域（中等）
> 79. 单词搜索（中等）
> 说明：以上问题都不建议修改输入数据，设置 visited 数组是标准的做法。可能会遇到参数很多，是不是都可以写成成员变量的问题，面试中拿不准的记得问一下面试官
>
> 题型三：字符串中的回溯问题
> 提示：字符串的问题的特殊之处在于，字符串的拼接生成新对象，因此在这一类问题上没有显示「回溯」的过程，但是如果使用 StringBuilder 拼接字符串就另当别论。
> 在这里把它们单独作为一个题型，是希望朋友们能够注意到这个非常细节的地方。
>
> 17. 电话号码的字母组合（中等），题解；
> 784. 字母大小写全排列（中等）；
> 22. 括号生成（中等） ：这道题广度优先遍历也很好写，可以通过这个问题理解一下为什么回溯算法都是深度优先遍历，并且都用递归来写。
> 题型四：游戏问题
> 回溯算法是早期简单的人工智能，有些教程把回溯叫做暴力搜索，但回溯没有那么暴力，回溯是有方向地搜索。「力扣」上有一些简单的游戏类问题，解决它们有一定的难度，大家可以尝试一下。
>
> 51. N 皇后（困难）：其实就是全排列问题，注意设计清楚状态变量，在遍历的时候需要记住一些信息，空间换时间；
> 37. 解数独（困难）：思路同「N 皇后问题」；
> 488. 祖玛游戏（困难）
> 529. 扫雷游戏（困难）
>
> 作者：liweiwei1419
> 链接：https://leetcode-cn.com/problems/permutations/solution/hui-su-suan-fa-python-dai-ma-java-dai-ma-by-liweiw/
> 来源：力扣（LeetCode）
> 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

[Leecode-46-全排列](https://leetcode-cn.com/problems/permutations/)✅

### 5. 递归

**场景使用：树**

**关键点**

- 确定终止条件
- 递归函数
- 参数返回值
- 单层递归逻辑

**框架**

```java
void dfs(Params... params){
  if(终止条件){
      return
  }
  for(集合元素){
    	处理节点
      递归函数
      返回上一层的值
  }
}
```





## 经典题目总结

### LRU缓存

https://leetcode-cn.com/problems/lru-cache/

> 函数 `get` 和 `put` 必须以 `O(1)` 的平均时间复杂度运行。

这道题主要是考察是**双向链表+HashMap**，HashMap满足查询的O(1)复杂度，配合上双向链表实现O(1)时间内找到指定Node并执行O(1)时间复杂度的移除/添加操作。

**双向链表**

```java
/**
  * 移除一个节点：断掉和该节点连接2条链条，然后把该节点对外的两条链置空。
  */
void removeNode(Node node)
/**
  * 加入一个节点到最前端：断掉Tail和头节点之间的2条链条，并指向插入节点，同时插入节点也要和他们建立2条链条。
  */
void addToTail(Node node)
```

**完整代码**

```java
package com.yt.test;

import java.util.HashMap;
import java.util.Map;

public class LRUCache {

    private final int capacity;
    private Map<Integer, ListNode> map;
    private ListNode start = new ListNode();
    private ListNode tail = new ListNode();

    public LRUCache(int capacity) {
        this.capacity = capacity;
        this.map = new HashMap<>();
        this.start.right = tail;
        this.tail.left = start;
    }

    /**
     * Your LRUCache object will be instantiated and called as such:
     * LRUCache obj = new LRUCache(capacity);
     * int param_1 = obj.get(key);
     * obj.put(key,value);
     */
    public static void main(String[] args) {
        LRUCache lruCache = new LRUCache(2);
        lruCache.put(1, 1);
        lruCache.Print(lruCache.start, "lruCache.put(1,1)");
        lruCache.put(2, 2);
        lruCache.Print(lruCache.start, "lruCache.put(2,2)");
        lruCache.get(1);
        lruCache.Print(lruCache.start, "lruCache.get(1)");
        lruCache.put(3, 3);
        lruCache.Print(lruCache.start, "lruCache.put(3,3)");
        lruCache.get(2);
        lruCache.Print(lruCache.start, "lruCache.get(2)");
        lruCache.put(1, 3);
        lruCache.Print(lruCache.start, "lruCache.put(1,3)");
        lruCache.put(3, 5);
        lruCache.Print(lruCache.start, "lruCache.put(3,5)");
        lruCache.put(4, 4);
        lruCache.Print(lruCache.start, "lruCache.put(4,4)");
        lruCache.get(1);
        lruCache.Print(lruCache.start, "lruCache.get(1)");
        lruCache.get(3);
        lruCache.Print(lruCache.start, "lruCache.get(3)");
        lruCache.get(4);
        lruCache.Print(lruCache.start, "lruCache.get(4)");
    }

    private void Print(ListNode start, String msg) {
        System.out.print(msg + "操作后双向链表：\t");
        System.out.print("start->");
        while (start.right != null && start.right != tail) {
            start = start.right;
            System.out.print("{" + start.key + ":" + start.value + "}" + "->");
        }
        System.out.print("tail");
        System.out.println();
    }

    public int get(int key) {
        ListNode node = map.get(key);
        if (node  null) return -1;
        removeNode(node);
        addToTail(node);
        return node.value;
    }

    public void put(int key, int value) {
        ListNode node = map.get(key);
        if (node  null) {
            node = new ListNode(key, value);
            if (map.size() >= capacity) {
                removeNode(start.right);//Remove Tail Node
            }
        } else {
            node.value = value;
            removeNode(node);//Remove Current Node
        }
        addToTail(node);//Add Node to Tail
    }

    private void removeNode(ListNode node) {
        ListNode left = node.left;
        ListNode right = node.right;
        if (left != null && right != null) {
            left.right = right;
            right.left = left;
        }
        node.left = null;
        node.right = null;
        map.remove(node.key);
    }

    private void addToTail(ListNode node) {
        ListNode left = tail.left;
        node.left = left;
        node.right = tail;
        left.right = node;
        tail.left = node;
        map.put(node.key, node);
    }

    class ListNode {
        ListNode left;
        ListNode right;
        int key;
        int value;

        public ListNode() {
        }

        public ListNode(int key, int value) {
            this.key = key;
            this.value = value;
        }
    }
}
```

```java
输出结果：
lruCache.put(1,1)操作后双向链表：	start->{1:1}->tail
lruCache.put(2,2)操作后双向链表：	start->{1:1}->{2:2}->tail
lruCache.get(1)操作后双向链表：	start->{2:2}->{1:1}->tail
lruCache.put(3,3)操作后双向链表：	start->{1:1}->{3:3}->tail
lruCache.get(2)操作后双向链表：	start->{1:1}->{3:3}->tail
lruCache.put(1,3)操作后双向链表：	start->{3:3}->{1:3}->tail
lruCache.put(4,4)操作后双向链表：	start->{3:5}->{4:4}->tail
lruCache.get(1)操作后双向链表：	start->{3:5}->{4:4}->tail
lruCache.get(3)操作后双向链表：	start->{4:4}->{3:5}->tail
lruCache.get(4)操作后双向链表：	start->{3:5}->{4:4}->tail
```

