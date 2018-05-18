## 命令列表
>ffmpeg -formats | less

## 查看视频信息

[命令]
>ffmpeg -i video.mp4 [video.mp4] 是视频文件
>ffmpeg -i test.flv 2>&1 | grep 'Duration' | cut -d ' ' -f 4 | sed s/,//

> ffprobe -v quiet -print_format json -show_format -show_streams zs_257573_HSCJC_XC_IMG.mp4

## 转换视频分辨率

[命令]
>ffmpeg -i vodeo_input.mp4 -s 640x480 -b 2000k -c:a copy video_output.mp4 [-s 视频分辨率 -b 码率（rate） -c:a copy代表复制原视频的视频和音频编码不做任何改， 最后输出output文件]

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

## 视频分割

### 按时长分割视频
```shell
ffmpeg -ss 60 -t 60  -i input.mp4 -c copy out-2.mp4
```
> * [-ss 开始时间的秒数 或者分钟数(00:01:00) -t 切割 n 秒长的视频，或者截止多长时间的视频(00:01:00)]

```shell
ffmpeg -re -i  input.mp4 -c copy -f segment -segment_format mp4 -segment_times 3,6,9 out.mp4
```
> * [视频按时间点切割 3,6,9  是 3 秒 6 秒 9 秒 分别切割出一段视频]

### 视频 mp4 转 ts
```python
subprocess.call(["ffmpeg", "-y", "-i", "concat:test.ts|test1.ts", "-acodec", "copy", "-vcodec", "copy", "-absf", "aac_adtstoasc", "out.mp4"])
```
