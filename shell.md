# shell 基础

标签 (空格分割) ：shell 工具

> 自我理解：shell脚本其实就是一些基础语法 + Linux命令的结合

## 1. 命令执行方式

1. 交互式：直接执行shell命令
2. 批处理：生成shell脚本执行 


## 2. 基础语法

### 1. 书写格式

**一个简单的脚本**

#### 示例
```shell
#/bin/bash

array=(11 22 33 44)
echo ${array[*]}
echo ${#array[@]}

for n in "${array[@]}"
do
	echo "for:${n}"
done

cat txt/20170331.txt | while read line
do
	if [ "${line}" == "a" ]
	then
		echo $line
	elif [ "${line}" == "b" ]
	then
		echo "line:${line}"
	elif [ $line == "1" ]
	then
		if [ $line -eq 1 ]
		then
			echo "line:${line}"
		fi
	else
		echo "${line}"
	fi
	
done
```
#### 示例解释
1. 脚本解析 /bin/bash
2. 定义数组 array = (1 2 3 4 5) //数组值已空格间隔
3. 输出数组全部数据 
4. 输出数组长度
5. for 循环示例，数组遍历
6. 按行读取文件内容到变量
7. 运算表达式

#### 表达式与运算符

1. 条件表达式

|表达式|示例|
|------|:---|
|[ expression ]|[ 1 -eq 1 ]|
|[[ expression ]]|[[ 1 -eq 1 ]]|
|test expression|test 1 -eq 1 ,等同于[]|

2. 整数比较

|比较符|描述|示例|
|------|:---:|:----:|
|-eq,equal    |等于  |[ 1 -eq 1 ] true|
|-ne,not equal|不等于|[ 1 -ne 2 ] true|
|-gt,greater than|大于|[ 2 -gt 1 ] true|
|-lt,lesser than|小于|[ 1 -lt 2 ] true|
|-ge,greater or equal|大于或等于|[ 2 -ge 1 ] true|
|-le，lesser or equal|小于或等于|[ 1 -le 2 ] true|

3. 字符串比较

|运算符|描述|
|------|:---:|
|==|等于|
|!=|不等于|
|>|大于|
|<|小于|
|<=|小于等于|
|>=|大于等于|
|-n|字符串长度不等于0 为真|
|-z|字符串长度等于0 为真|
|str|字符串存在为真|

4. 逻辑符

|逻辑符|描述|
|------|:---:|
|&&|并且|
| '||' |或者|

5. 运算表达式

|运算表达式|描述|
|------|:---:|
|$(())|$((1+1)),$((i+1))|
|$[]|$[1+1]|

#### 函数

```shell
#/bin/bash
demoFunc() {
	echo "echo a demo func"
}

demoFunc
```

#### 传入参数

> sh shell.sh a

```shell
#/bin/bash
echo $1
```
