## Makefile

### 生成方式

1. 手动生成Makefile
2. 通过autoconf自动生成Makefile

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

>Autoconf 是一个用于生成可以自动地配置软件源码包，用以适应多种UNIX类系统的shell脚本工具，其中autoconf依赖软件 m4，便于生成脚本。
autoscan,autoconf,automake 配合生成Makefile。

>automake是一个从Makefile.am文件自动生成Makefile.in的工具。为了生成Makefile.in，automake还需用到perl，由于automake创建的发布完全遵循GNU标准，所以在创建中不需要perl。libtool是一款方便生成各种程序库的工具。

**步骤**
1. 创建目录，生成一个hello.c
2. 执行 autoscan 命令，生成configure.in模版文件 configure.scan
3. 编辑configure.in文件
```shell
#AC_PREREQ() #版本号
AC_INIT() #可执行文件
AM_INIT_AUTOMAKE() #指示可执行文件于版本号
#AC_CONFIG_SRCDIR() #检验文件是否缺失
#AC_CONFIG_HEADERS() 检查头文件config.h
AC_PROG_CC #检查C语言编译程序是否存在
AC_OUTPUT(Makefile) #最终输出的文件

#每个configure.scan 文件都是以AC_INT 开头 AC_OUTPUT 结尾
```
4. 执行 aclocal 和 autoconf 生成 aclocal.m4 和 configure
5. 编辑 Makefile.am文件
```shell
UTOMAKE_OPTIONS=foreign  #不检查NEWS，AUTHOR，ChangeLog
bin_PROGRAMS=hello   #要生成的可执行应用程序文件
hello_SOURCES=hello.c　　//表示生成可执行应用程序所用的源文件
```
6. 运行automake
7. 执行./configure 生成Makefile文件
8. 使用Makefile编译代码  make
9. ./hello 执行已编译文件

![Aaron Swartz](https://github.com/jiashaokun/doc/blob/master/txt/auto.png)
