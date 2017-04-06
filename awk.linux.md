# Linux 命令

## awk 

### 调用方式

[命令行]
>awk [-F  field-separator]  'commands'  file
commands 是真正awk命令，[-F域分隔符]是可选的。 file 是待处理的文件。
在awk中，文件的每一行中，由域分隔符分开的每一项称为一个域。通常，在不指名-F域分隔符的情况下，默认的域分隔符是空格。

[shell 脚本调用]
>将所有的awk命令插入一个文件，并使awk程序可执行，然后awk命令解释器作为脚本的首行，一遍通过键入脚本名称来调用。
相当于shell脚本首行的：#!/bin/sh  换成 #!/bin/awk

### 参数解释

>* -F 间隔符，默认空格
>* print 按间隔数据打印第$n 个值

[示例] 从文件中按 ':' 间隔读取第二个
```shell
cat txt/linux.txt | awk -F ':' '{print $2}'
zwk -F 'print $2' txt/linux.txt
```

>* BEGIN 首行输入
>* END 在末尾追加

```shell
cat txt/linux.txt | awk  'BEGIN {print "num1 \t num2"} {print $1"\t"$2} END {print "ends"}'
```


