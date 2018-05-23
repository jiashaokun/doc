## 命令列表
>ffmpeg -formats | less

>GPU查看命令 watch -n 10 nvidia-smi

[http://www.cnblogs.com/wainiwann/p/4128154.html]

## 查看视频信息

[命令]
```shell
ffmpeg -i video.mp4  # [video.mp4] 是视频文件

ffmpeg -i test.flv 2>&1 | grep 'Duration' | cut -d ' ' -f 4 | sed s/,//   # 获取视频文件播放时长

ffprobe -v quiet -print_format json -show_format -show_streams zs_257573_HSCJC_XC_IMG.mp4 # 获取视频文件全部信息
```

## 转换视频分辨率

[命令]
>ffmpeg -i vodeo_input.mp4 -s 640x480 -b 2000k -c:a copy video_output.mp4 [-s 视频分辨率 -b 码率（rate） -c:a copy代表复制原视频的视频和音频编码不做任何改， 最后输出output文件]

```shell
# 使用gpu
ffmpeg -i input.mp4 -c:v h264_nvenc -s 640x480 -b:v 600k output.mp4
```

## 文件类型设置

[命令]
>ffmpeg -i video_input.avi -target vcd vcd.mpg [target 转换文件为 vcd 格式 并输出]

## 视频转码设置无损 x264

[命令]
>ffmpeg -i video_input.mp4 -c:v libx264 -preset veryslow -crf 18 -c:a copy output.mp4 

[x264提供三种码率控制的方式，bitrate,qp,crf 三种是互斥的，使用时设置其一]

>-bitrate: 会尝试用给定的元率作为整体平均值来编码，这意味着最终编码文件大小是已知的，但文件质量未知，所以通常与 -pass 一起使用
>-qp : 当qp为0 时，无损编码
>-crf: (取值范围 1-51)取值越小质量越好码率越高，降低没有必要的针来提高质量，crf = 0时 与 qp=0 相同

>-preset: 调节编码速率和质量的平衡(有ultrafast、superfast、veryfast、faster、fast、medium、slow、slower、veryslow、placebo这10个选项，从快到慢)
>-tune: 主要配合视频类型和视频优化的参数，

### 参考
> [https://wenku.baidu.com/view/f4e48c087fd5360cba1adbba.html]

>ffmpeg -i vodeo_input.mp4 -s 640x480 -b 2000k -c:a copy video_output.mp4 [-s 视频分辨率 -b 码率（rate） -c:a copy代表复制原视频的视频和音频编码不做任何改， 最后输出output文件]切割

## 视频分割 && 合并
> * 操作流程 [1. 视频分割成一小段mp4格式小视频 2. 将小视频转为 ts 格式小视频 3. 合并所有ts小视频为 mp4 格式视频]
## 视频分割 && 合并

### 按时长分割视频
```shell
ffmpeg -ss 60 -t 60  -i input.mp4 -c copy out-2.mp4
```
> * [-ss 开始时间的秒数 或者分钟数(00:01:00) -t 切割 n 秒长的视频，或者截止多长时间的视频(00:01:00)]

```shell
ffmpeg -re -i  input.mp4 -c copy -f segment -segment_format mp4 -segment_times 3,6,9 out.mp4
```
> * [视频按时间点切割 3,6,9  是 3 秒 6 秒 9 秒 分别切割出一段视频]

```shell
ffmpeg -i 33521499_401181_1525176287.mp4 -f segment -strftime 1 -segment_time 60 -segment_format mp4 out%Y-%m-%d_%H-%M-%S.mp4
```
> * [按分钟切割]

### 视频 mp4 转 ts格式
```python
subprocess.call(["ffmpeg", "-y", "-i", "/Users/master/yx/yxp/web/video/online/test1.mp4", "-vcodec", "copy", "-acodec", "copy", "-vbsf", "h264_mp4toannexb", "/Users/master/yx/yxp/web/video/online/test1.ts"])
```
### 视频合并  多个ts文件视频 合并成 mp4
```python
subprocess.call(["ffmpeg", "-y", "-i", "concat:test.ts|test1.ts", "-acodec", "copy", "-vcodec", "copy", "-absf", "aac_adtstoasc", "out.mp4"])
```

### 视频切割并生成ts文件
```shell
ffmpeg -i input.mp4 -c:v libx264 -c:a copy  -hls_time 60 -hls_list_size 0 -f hls output.m3u8
```
> * hls_time 设置每片的长度，默认值为2。单位为秒
> * hls_list_size 设置播放列表保存的最多条目，设置为0会保存有所片信息，默认值为5
> * hls_wrap  设置多少片之后开始覆盖，如果设置为0则不会覆盖，默认值为0项能够避免在磁盘上存储过多的片，而且能够限制写入磁盘的最多的片的数量
> * start_number 设置播放列表中sequence number的值为number，默认值为0 提示：播放列表的sequence number 对每个segment来说都必须是唯一的，而且它不能和片的文件名混淆，因为在，如果指定了“wrap”选项文件名会出现重复使用

> * -threads 1 使用线程数 
