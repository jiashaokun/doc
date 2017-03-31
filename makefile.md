# Makefile

标签（空格分隔）： 工具 go

> makefile介绍：make 执行时，需要有一个makefile文件来告诉make命令需要执行某些命令或者怎么样去编译文件

**工作步骤**
>* 读入所有的Makefile
>* 读入inclode的Makefile
>* 初始化文件中的变量
>* 推导规则并分析推导
>* 为所有目标创建依赖关系链
>* 根据依赖关系决定哪些目标要重新生成
>* 执行命令


**书写格式**

```Makefile
build:
	g++ hello.cpp
clean:
	rm  a.out
now:
	date +%Y.%m.%d-%H:%M:%S
```
