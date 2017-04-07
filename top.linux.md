## Linux - top 命令

### Top 命令详解

>top动态显示过程，状态，提供实时系统资源的监控

### 第一行是任务队列信息

top - 17:22:01 up 432 days,  3:33,  1 user,  load average: 1.54, 0.74, 0.52

17:22:01 当前时间

up 432 days,  3:33 系统运行时间

1 user  当前登陆用户数

load average: 1.54, 0.74, 0.52  系统负载，即任务队列的平均长度。 三个数值分别为  1分钟、5分钟、15分钟前到现在的平均值

### 第二行任务信息

Tasks: 581 total,   1 running, 580 sleeping,   0 stopped,   0 zombie

581 total 总进程数

1 running  正在运行的进程 1 个

580 sleeping  沉睡进程 580 个

0 stopped   停止的进程 0 个

0 zombie  僵尸进程 0 个

### 第三行CPU信息

Cpu(s): 14.0%us,  1.5%sy,  0.0%ni, 83.8%id,  0.0%wa,  0.0%hi,  0.8%si,  0.0%st

14.0%us  当前cpu使用率

1.5%sy  内核空间占用率

0.0%ni  用户进程空间内改变过优先级的进程占用率

83.8%id  cpu空闲

0.0%wa  等待输入输出的cpu占用率

0.0%hi  硬中断占用cpu的百分比

0.8%si 软终端占用cpu的百分比

0.0%st 虚拟 CPU 等待实际 CPU 的时间的百分比

### 第四，五行 内存信息

Mem:  24565588k total, 22218712k used,  2346876k free,   263816k buffers

Swap:  6143996k total,   853536k used,  5290460k free, 14156284k cached

Mem:  24565588k total 物理内存总量

22218712k used  使用物理内存总量

2346876k free  空闲内存总量

263816k buffers 用作内核缓存的内存总量

Swap:  6143996k total 交换去内存总量

853536k used 使用交换去内存总量

5290460k free 交换去剩余内存总量

14156284k cached 缓冲的交换去总量。

### 进程信息

|Name|解释|
|----|:--:|
|PID|进程id|
|USER|启动进程用户|
|PR|优先级|
|NI|nice 负表示高优先级 正表示低优先级|
|VIRI|进程使用的虚拟内存总量|
|RES|进程使用，未被换出的物理内存|
|SHR|共享内存大小 单位Kb|
|S|进程状态：D:不可中断的睡眠状态，R:运行，S:睡眠T:跟踪/停止Z:僵尸|
|%CPU|CPU时间占用百分比|
|%MEM|进程使用物理内存百分比|
|TIME+|进程使用的CPU时间总计，单位1/100秒|
|COMMAND|命令名|
