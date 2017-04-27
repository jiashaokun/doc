## Makefile

>Makefile 是由 make 命令引用的文本文件，它描述了目标的构建方式，并包含诸如源文件级依赖关系以及构建顺序依赖关系之类的信息。

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

>最简单的理解Makefile文件书写就是tag+shell命令的组装,不一定文件一定要是Makefile，比如可以 make -f aa.txt

**书写规则**

```shell
target ... : prerequisites ...
command

tag:	#标签
commend	#shell命令
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
	gcc -c print.c

#标签格式
clean: #标签定义
	rm helloworld main.o print.o
```

**自动生成依赖**
>上述代码是手动依赖，那如果需要依赖很多个文件是不是优点头疼

```shell
gcc -M file #命令行执行,查询main.c 的文件依赖
#gcc -MM file 或者试试这个
```
<img src="https://github.com/jiashaokun/doc/blob/master/txt/cc-m.jpg" width = "490" height = "151" align=center />

**Makefile嵌套**
>在工程中Makefile文件是根据目录走的，这样有助于Makefile的维护，所以就会产生多个目录中的Makefile的嵌套

```shell
system:
	cd dir && $(MAKE)
#根目录的Makefile文件，先进入 dir目录 再执行make命令
```

>在规则中使用通配符

```shell
clean:
	cat files #还可以加入其他linux命令
	rm -rf *.swp
```

>另外，使用 make -w 可以看到make命令执行的过程

<img src="https://github.com/jiashaokun/doc/blob/master/txt/make-w.jpg" width = "326" height = "105" align=center />

**显示命令**
>上述Makefile中的命令会被输出到显示屏上，可以设置不显示

1. 命令行前加 @ 符号
```shell
clean:
	@rm -rf *.swp
```
2. make -s

### 文件搜寻

**Makefile 中增加目录设置**

>在工程目录中，有大量的源文件是分类存放到不同目录的，所以在写Makefile时，需要寻找依赖关系时可以在文件前加上路径，VPATH=... ，如果没有指定路径，make只会在当前目录查找依赖文件和目标文件。

```shell
VPATH = src:../headers
```

**使用make的 vpath （小写）关键字**

vpath <pattern> <directories>
pattern:符合模式
directories:文件指定搜索目录

```shell
vpath %.h ../headers #该语句表示，要求make在“../headers”目录下搜索所有以“.h”结尾的文件。（如果文件在当前目录没有找到的话）
```

我们可以连续地使用vpath语句，以指定不同搜索策略。
>其表示“.c”结尾的文件，先在“foo”目录，然后是“bl,最后是“bar”

```shell
vpath %.c foo
vpath %.c blish
vpath %.c bar
```

>或者：表示“.c”结尾的文件，先在“foo”目录，然后是“bar”目录，最后才是“bli

```shell
vpath %.c foo:bar #由此可见，目录间隔符号，使用英文冒号间隔
vpath %.c blish
```


### 二 自动生成方式

>autoscan,aclocal,autoconf,automake 配合生成Makefile。

>Autoscan autoscan命令通常在生成Makefile文件中以检查基础配置为主要内容，通过aotuscan命令生成configure.scan,它是configure.ac（configure.in）的一个雏形。

>Aclocal 是一个perl脚本程序，用于为autoconf提供模版支持。aclocal 命令生成aclocal.m4

>Autoconf 依赖aclocal.m4 是一个用于生成可以自动地配置软件源码(configure)的工具,Autoconf产生的配置脚本在使用时不需要用户手动干预。

>Automake 是一个从Makefile.am(人为创建) 文件自动生成Makefile.in的工具。用于生成最终编译文件。

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
UTOMAKE_OPTIONS=foreign  #提供了三种软件等级：foreign、gnu和gnits，默认等级为gnu。foreign 只检查必要文件
bin_PROGRAMS=hello   #要生成的可执行应用程序文件
hello_SOURCES=hello.c　　//生成"hello" 可执行应用程序 所用的 源文件
```
6. 运行automake
```shell
其中可能会遇到以下问题信息, 创建相关文件即可

Makefile.am: required file `./NEWS' not found
Makefile.am: required file `./README' not found
Makefile.am: required file `./AUTHORS' not found
Makefile.am: required file `./ChangeLog' not found
```

7. 执行./configure 生成Makefile文件
8. 执行make命令使用Makefile编译代码
9. ./hello 执行已编译文件

<img src="https://github.com/jiashaokun/doc/blob/master/txt/auto.png" width = "320" height = "570" align=center />
