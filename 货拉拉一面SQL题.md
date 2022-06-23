```sql
select 
	university,gender,COUNT(*) as user_cnt,AVG(active_days_within_30) as aver_within_30, AVG(question_cnt) as 	     aver_ques_cnt
	OVER (partitions by university) 
	from user_profile 
	group by gender;
```



```sql
select u.device_id as device_id, university, count(q.question_id) as question_cnt, 
SUM(IF(q.result='right',1,0)) as right_question_cnt 
from user_profile u
left join question_practice_detail q
ON u.device_id = q.device_id and q.date between '2021-08-01' and '2021-08-31'
where
university = '复旦大学'
group by device_id;
```



| 题目： 现在运营想要了解复旦大学的每个用户在8月份练习的总题目数和回答正确的题目数情况，请取出相应明细数据，对于在8月份没有练习过的用户，答题数结果返回0. |                          |              |                    |               |      |
| ------------------------------------------------------------ | ------------------------ | ------------ | ------------------ | ------------- | ---- |
| 用户信息表                                                   | user_profile             |              |                    |               |      |
| id                                                           | device_id                | gender       | age                | university    | gpa  |
| 1                                                            | 2138                     | male         | 21                 | 北京大学      | 3.4  |
| 2                                                            | 3214                     | male         |                    | 复旦大学      | 4    |
| 3                                                            | 6543                     | female       | 20                 | 北京大学      | 3.2  |
| 4                                                            | 2315                     | female       | 23                 | 浙江大学      | 3.6  |
| 5                                                            | 5432                     | male         | 25                 | 山东大学      | 3.8  |
| 6                                                            | 2131                     | male         | 28                 | 山东大学      | 3.3  |
| 7                                                            | 4321                     | female       | 26                 | 复旦大学      | 3.6  |
| 回答结果表                                                   | question_practice_detail |              |                    |               |      |
| id                                                           | device_id                | question_id  | result             | date          |      |
| 1                                                            | 2138                     | 111          | wrong              | 2021/5/3      |      |
| 2                                                            | 3214                     | 112          | wrong              | 2021/5/9      |      |
| 3                                                            | 3214                     | 113          | wrong              | 2021/6/15     |      |
| **4**                                                        | **6543**                 | **111**      | **right**          | **2021/8/13** |      |
| **5**                                                        | **2315**                 | **115**      | **right**          | **2021/8/13** |      |
| **6**                                                        | **2315**                 | **116**      | **right**          | **2021/8/14** |      |
| **7**                                                        | **2315**                 | **117**      | **wrong**          | **2021/8/15** |      |
| ……                                                           |                          |              |                    |               |      |
| 根据示例，返回以下结果：                                     |                          |              |                    |               |      |
| device_id                                                    | university               | question-cnt | right_question_cnt |               |      |
| 3214                                                         | 复旦大学                 | 3            | 0                  |               |      |
| 4321                                                         | 复旦大学                 | 0            | 0                  |               |      |
|                                                              |                          |              |                    |               |      |