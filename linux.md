## Linux 经典命令

1. 删除 0 字节文件
find -type f -size 0 -exec rm -rf {} \;

2. 统计访问日志中来自同ip出现的次数分析盗链、攻击、机器人
cat access.log |awk ‘{print $1}’| sort | uniq -c |sort -

3. 按CPU使用从大到小排列
ps -e -o "%C : %p : %z : %a"|sort-nr
