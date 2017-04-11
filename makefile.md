## Makefile

### 生成方式

1. 手动生成Makefile
2. 自动生成Makefile

### make 的工作方式

>make命令执行时，需要有一个Makefile文件告诉make命令要如何编译和运行程序,其最终目标是寻找Makefile中的tag，并执行命令

>* 读入所有的Makefile
>* 读入inclode的Makefile
>* 初始化文件中的变量
>* 推导规则并分析推导
>* 为所有目标创建依赖关系链
>* 根据依赖关系决定哪些目标要重新生成
>* 执行命令

### 一 手动生成方式

**书写规则**

```shell
target ... : prerequisites ...
command
```

>* target 可以是一个目标文件，也可以是一个执行文件，也可以是一个标签。
>* prerequisites 要生成target所需的文件或者目标。
>* command make需要执行的命令。（shell命令）

>target这一个或者多个文件依赖于prerequisites中的文件，其中生成的规则定义在command中

```shell
objs = main.o print.o #定义变量
helloworld : $(objs)
	gcc -o helloworld $(objs)
mian.o : mian.c print.h
	gcc -c main.c
print.o : print.c print.h
	#gcc -c print.c 自动推导
clean: #标签定义
	rm helloworld main.o print.o
```


### 二 自动生成方式

1. 运行autoscan生成configure.in
2. 重命名configure.scan 为 configure.in
3. 修改 configure.in 文件
4. 新建makefile.am文件
