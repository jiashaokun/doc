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

```shell
(1) -an: 去掉音频 
(2) -vn: 去掉视频 
(3) -acodec: 设定音频的编码器，未设定时则使用与输入流相同的编解码器。音频解复用在一般后面加copy表示拷贝 
(4) -vcodec: 设定视频的编码器，未设定时则使用与输入流相同的编解码器，视频解复用一般后面加copy表示拷贝 
(5) –f: 输出格式（视频转码）
(6) -bf: B帧数目控制 
(7) -g: 关键帧间隔控制(视频跳转需要关键帧)
(8) -s: 设定画面的宽和高，分辨率控制(352*278)
(9) -i:  设定输入流
(10) -ss: 指定开始时间（0:0:05）
(11) -t: 指定持续时间（0:05）
(12) -b: 设定视频流量，默认是200Kbit/s
(13) -aspect: 设定画面的比例
(14) -ar: 设定音频采样率
(15) -ac: 设定声音的Channel数
(16)  -r: 提取图像频率（用于视频截图）
(17) -c:v:  输出视频格式
(18) -c:a:  输出音频格式
(18) -y:  输出时覆盖输出目录已存在的同名文件

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

```shell
# t.txt 内容
file 't1.ts'
file 't2.ts'
#  视频合并
ffmpeg -f concat -i t.txt -vcodec h264_nvenc -acodec copy -f mp4 yx_o1.mp4
```

```shell
ffmpeg -i /data1/product/v4/assets/video/ct.ts -i com/zs_710587_CT.mp4 -i /data1/product/v4/assets/video/cw.ts -i com/zs_710587_CW.mp4 -filter_complex "[0:0][0:1][1:0][1:1][2:0][2:1][3:0][3:1] concat=n=4:v=1:a=1" -c:v copy -vcodec h264_nvenc -y tt.mp4
```

>* 上面的命令合并了三种不同格式的文件，FFmpeg concat 过滤器会重新编码它们。注意这是有损压缩。 
[0:0] [0:1] [1:0] [1:1] [2:0] [2:1] 分别表示第一个输入文件的视频、音频、第二个输入文件的视频、音频、第三个输入文件的视频、音频。concat=n=3:v=1:a=1 表示有三个输入文件，输出一条视频流和一条音频流。[v] [a] 就是得到的视频流和音频流的名字，注意在 bash 等 shell 中需要用引号，防止通配符扩展   [http://www.voidcn.com/article/p-xzdyrfxk-bhs.html]

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
```shell
ffmpeg -y -i input.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb out.ts
```
### 视频合并  多个ts文件视频 合并成 mp4
```python
ffmpeg -y -i "concat:test.ts|test1.ts" -acodec copy -vcodec copy -absf aac_adtstoasc out.mp4
```
```shell
# list.txt 内容 file 'out-1.mp4'
ffmpeg -f concat -i list.txt -c copy concat.mp4

# or
ffmpeg -y -i input.mp4 -ignore_loop 0 -i ICON_01.gif -filter_complex "overlay=x=10:y=10:shortest=1" -vcodec h264_nvenc -acodec copy -f mp4 out.mp4
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

### 视频切割 按每分钟切割
```shell
ffmpeg  -i input.mp4 -c copy -map 0 -f segment -segment_time 60 out_mp4_%d.mp4
```

### 视频切割 按时间进行切割(segment_time 秒)
```shell
ffmpeg -i input_file [-i inputfile] -c copy -map 0 -f segment -segment_time 秒 输出_目录/文件名称_%d.mp4
```
### 硬编码 [url:https://developer.nvidia.com/ffmpeg]
> * [需要机器支持GPU 并支持 NVIDIA 显卡驱动和 CUDA] 
```shell
ffmpeg -y -i input_file.mp4 -c:v h264_nvenc -s 1280x720 -b:v 2000k out.mp4

ffmpeg -y -i input.mp4 -c:v h264_nvenc -vcodec h264_nvenc -s 1280x720 -b:v 2000k -f mp4 out.mp4
```
### 选择使用GPU
```python
    # 生成随机数
    r = random.randint(0,1)
    os.environ["CUDA_DEVICE_ORDER"]="PCI_BUS_ID"
    # 随机使用第r块GPU
    os.environ["CUDA_VISIBLE_DEVICES"] = str(r)
```
> * 使用 GPU 硬编码
```shell
# 1 to 1
ffmpeg -hwaccel cuvid -c:v h264_cuvid -i <input.mp4> -vf scale_npp=1280:720 -c:v h264_nvenc <output.mp4>
# 1 to n
ffmpeg -hwaccel cuvid -c:v h264_cuvid -i <input.mp4> -vf scale_npp=1280:720 -vcodec h264_nvenc <output0.mp4> -vf scale_npp 640:480 -vcodec h264_nvenc <output1.mp4>
```

### 视频加图片水印
```shell
# 使用 硬编码  50:50（x:y 坐标）
ffmpeg -y -i input.mp4 -vf "movie=logo.png[wm]; [in][wm]overlay=50:50[out]" -c:v h264_nvenc output.mp4

# 正常编码
ffmpeg -y -i input.mp4 -vf "movie=logo.png[wm]; [in][wm]overlay=50:50[out]" output.mp4

# overlay=x=main_w-120:y=40  （logo在视频位置距离：logo左边距,距离视频 右边距 120 px logo 距离顶部 40 px）
ffmpeg -y -i cs_16794_FDJC.mp4 -vf "movie=logo.png[wm]; [in][wm]overlay=x=main_w-120:y=40[out]" output.mp4

# 插入多张图
ffmpeg -y -i input.mp4 -vf "movie=logo.png [wm]; movie=ct.png[wm1];[c][wm]overlay=x=100:y=100 [out];[out][wm1] overlay=x=400:y=400" -f mp4 logo.mp4

# 或者
ffmpeg -i zs_420714_CT.mp4 -i 1.png -i 2.png -filter_complex "overlay=x=100:y=100:enable='if(gt(t,5),lt(t,10))',overlay=x=100:y=100:enable='if(gt(t,15),lt(t,20))'" -y 0.mp4
```

# FFmpeg 音频

### ffmpeg 视频静音
```shell
    ffmpeg -i input.mp4 -i mute.mp3 -map 0:0 -map 1:0 -c copy output.mp4
    # 这里，0：0中的第一个数字是输入文件（0代表视频文件，1代表音频文件），第二个数字是来自该文件的数据流（0，因为每个流只有一个视频或音频） 。这两个流将被映射到一个输出文件，所以第一个视频，然后是音频
```

### ffmpeg 视频静音后 添加一段音频
```shell
# 1 将视频流进行分离，分离出没有音频的视频
ffmpeg -i input.mp4 -vcodec copy -an out.mp4   //分离视频流
# 将 mp3 音频文件转成 wav 
ffmpeg -i music.mp3 music.wav
# 或者 阶段相同视频长度的音频
ffmpeg -i music.wav -ss 0 -t 37 musicshort.wav

# 将音频合并到视频中(从第视频起始合并)
ffmpeg -i musicshort.wav -i out.mp4 out1.mp4

# 将音频插入到视频的某一个时间
ffmpeg -y -i mute/cs_16794_FDJC.mp4 -itsoffset 00:00:5 -i yqns.wav -map 0:0 -map 1:0 -c:v copy -preset ultrafast -async 1 o2.mp4

# 视频一次添加多个语音文件在指定时间（先静音,不能为mp3格式）
ffmpeg -i input.mp3 -acodec alac -ab 128k -ar 48000 -ac 2 -y output.m4a 

ffmpeg -i input.mp4 -itsoffset 10.555 -i ct.m4a -itsoffset 20.999 -i ct.m4a -itsoffset 70 -i ct.m4a -map 0:1 -map 1:0 -map 2:0 -map 3:0 -c:v copy -preset ultrafast -f mp4 -y out1.mp4
```

### 视频防抖动
```shell
ffmpeg -y -i o1.mpeg -vf vidstabtransform=smoothing=30 -c:v h264_nvenc o2.mpeg
```

## 视频多宫格处理
```shell
ffmpeg -re -i yx_test_dd.mp4 -re -i o22.mp4 -filter_complex "nullsrc=size=1280x720 [base]; [0:v] setpts=PTS-STARTPTS,scale=680x400 [upperleft]; [1:v] setpts=PTS-STARTPTS, scale=680x480 [upperright]; [base][upperleft] overlay=shortest=1[tmp1];[tmp1][upperright] overlay=shortest=1:x=680" -c:v h264_nvenc o33.mp4
```

### 复制并生成某个时长的音频
```shell
# 循环 5 遍，长 10 秒
ffmpeg -stream_loop 5 -i ct.mp3 -t 10 ct_out.mp3
```

### 将一个 音频 放到 某个静音视频的头部，若音频较短，则生成于视频相同时长的静音进行填补
```shell
ffmpeg -i mute/cs_16794_FDJC.mp4 -i ct.mp3 -filter_complex "[1:0]apad" -shortest o1.mp4
```

### 音频固定时间插入音频
```shell
# 1 将第一个音频 第一个声道 延迟 n 秒播报 （5秒）
ffmpeg -y -i cw.mp3 -filter_complex adelay="5000" cwc.mp3

# 音频批量延迟 自定义各自延迟 n 秒 （10000 = 10秒）
ffmpeg -y -i ct.mp3 -i cw.mp3 -filter_complex "[0:0]adelay=10000[o1];[1:0]adelay=20000[o2]" -map "[o1]" t1.mp3 -map "[o2]" t2.mp3

# 2 将第 主音频 于插入音频混合 
ffmpeg -y -i ovc.mp3 -i cwc.mp3 -filter_complex amix=inputs=2:duration=longest:dropout_transition=3 o3.mp3

# 或者 mp4 直接合并 mp4 
ffmpeg -y -i o1.mp4 -i cwc.mp3 -filter_complex amix=inputs=2:duration=longest:dropout_transition=3 -vcodec copy ov3.mp4

# 多个合并
ffmpeg -i INPUT1 -i INPUT2 -i INPUT3 -filter_complex amix=inputs=3:duration=first:dropout_transition=3 OUTPUT
```

### ffmpeg 视频加文字水印
```shell
#  需要字体 FreeSerif.ttf 文件 [https://fonts2u.com/download/free-serif.family][https://fonts2u.com/free-serif.font]
ffmpeg -y -i 64862406_525441_1526891425.mp4 -vf "drawtext=fontsize=100:fontfile=FreeSerif.ttf:text='hello world' :fontcolor=white"  o4.mp4

# 同时添加多个文字水印，并且 指定某个文字 在第几秒显示 显示截止到第几秒
ffmpeg -y -i zs_420714_ZQCS.mp4 -vf "[in]drawtext=fontsize=36:fontfile=PingFang-SC-Regular.ttf:text='正在检查漆膜厚度':x=100:y=100:enable='if(gt(t,10),lt(t,20))':fontcolor=white[a1];[a1]drawtext=fontsize=36:fontfile=PingFang-SC-Regular.ttf:text='正在检查漆膜厚度':x=200:y=200:fontcolor=white [out]"  o4.mp4
```

### 图片生成视频
```shell
ffmpeg -r 25 -start_number 2 -i img%d.png -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
# or
ffmpeg -r 25 -start_number 2 -i img%d.png -s:v 1280x720 -c:v libx264 -profile:v high -r 30 -pix_fmt yuv420p out.mp4
```

### png 转 gif
```shell
# 将图片生成 png  img1.png img2.png img3.png
ffmpeg -i img%d.png -vf palettegen palette.png

# 将图片根据 生成的 png 生成 gif
ffmpeg -v warning -i img%d.png -i palette.png  -lavfi "paletteuse,setpts=6*PTS" -y out.gif
```

### gif 添加到视频 循环播放
```shell
# apng 图片格式必须是 rgba 不能提供 pal8 （png 针图生成 apng 图url[https://github.com/jiashaokun/doc/blob/master/png_create_apng/ChangeReso.sh]）
# scale 设置缩放比  n 越大 gif 越小
ffmpeg -y -i input.mp4 -ignore_loop 0 -i out1.gif -filter_complex 'overlay=x=100:y=100:shortest=1' out8.mp4

# or

ffmpeg -y -i zs_420714_CT.mp4 -filter_complex 'movie=c_01.png:loop=0[animation];[0:v][animation]overlay=x=100:y=100:shortest=1' out.mp4

# exp
ffmpeg -y -i input.mp4 -ignore_loop 0 -i p1.png -filter_complex '[0:v]scale=iw:ih[a];[1:v]scale=150:98[wm];[a][wm]overlay=x=30:y=30:shortest=1' -preset faster out.mp4
```

### ffmpeg 添加字幕文件

```shell
ffmpeg -i zs_712837_ZQCS.mp4 -vf subtitles=test.srt -vcodec h264_nvenc -y o3.mp4

# 如果视频文件出现乱码的情况，观察编译过程：[Parsed_subtitles_0 @ 0x2012b40] fontselect: (Arial, 400, 0) -> /usr/share/fonts/lyx/msam10.ttf, 0, PingFangSC

# MMB被这个坑了好长时间 走的是 PingFangSC 字体，找的却是 msam10.ttf 外星文，妈的，骂人，反正我不懂，我就开骂，处理如下
# cp /usr/share/fonts/lyx/msam10.ttf /usr/share/fonts/lyx/msam10.ttf_base
# cp ../assets/font/PingFang-SC-Regular.ttf /usr/share/fonts/lyx/msam10.ttf
```
### ffmpeg 同时添加图片和文字水印
```shell
ffmpeg -y -i tt.mp4 -i logo.png -filter_complex "[0:v]drawtext=fontfile=PingFang-SC-Regular.ttf:text='测试一下':fontcolor=#FFFFFF:fontsize=36:x=100:y=100[text];[text][1:v]overlay=0:0[out]" -map "[out]" -map 0:a -codec:v libx264 -codec:a copy output.mp4

# 限制显示时间

ffmpeg -y -i tt.mp4 -i logo.png -filter_complex "[0:v]drawtext=fontfile=PingFang-SC-Regular.ttf:text='测试一下':fontcolor=#FFFFFF:fontsize=36:x=100:y=100:enable='if(gt(t,5),lt(t,10))'[text];[text][1:v]overlay=0:0:enable='if(gt(t,5),lt(t,10))'[out]" -map "[out]" -map 0:a -codec:v libx264 -codec:a copy output.mp4

# 乱序 (文字和图片水印顺序不固定 不支持多个)
ffmpeg -i test.mp4 -vf "movie=logo.png[w1];drawtext=text='HelloWorld':fontfile=PingFang-SC-Regular.ttf:fontsize=25:x=500:y=500:enable='if(gt(t,10),lt(t,20))':fontcolor=white[w2];[w2][w1]overlay=x=100:y=100:enable='if(gt(t,10),lt(t,20))'" -f mp4 -y out.mp4
```

### 同时打入 图片水印 和 字幕
```shell
ffmpeg -i test.mp4 -i logo.png -i logo.png -filter_complex "overlay=x=100:y=100:enable='if(gt(t,5),lt(t,10))',overlay=x=100:y=100:enable='if(gt(t,15),lt(t,20))', subtitles=tt.srt" out.mp4
```

### 同时打入 图片水印 字幕 apng 文字水印
```shell
ffmpeg -i test.mp4 -i logo.png -i logo.png -ignore_loop 0 -i ct.apng -filter_complex "overlay=x=100:y=100:enable='if(gt(t,5),lt(t,10))',overlay=x=100:y=100:enable='if(gt(t,15),lt(t,20))', overlay=x=300:300:shortest=1, subtitles=tt.srt,drawtext=text='hello':fontfile=PingFang-SC-Regular.ttf:x=100:y=100:enable='if(gt(t,10),lt(t,20))':fontcolor=white,drawtext=text='world':fontfile=PingFang-SC-Regular.ttf:x=200:y=200:enable='if(gt(t,10),lt(t,20))':fontcolor=white" out.mp4

ffmpeg -i input.mp4 -ignore_loop 0 -i ct.apng -i p1.png -i p2.png -filter_complex "overlay=x=300:300:shortest=1, overlay=x=100:y=100:enable='if(gt(t,5),lt(t,10))',overlay=x=100:y=100:enable='if(gt(t,15),lt(t,20))', subtitles=txt.srt,drawtext=text='正在检查...':fontfile=siyuan-heiti-normal.ttf:x=100:y=100:enable='if(gt(t,10),lt(t,20))':fontcolor=white,drawtext=text='正在检查...':fontfile=siyuan-heiti-normal.ttf:x=200:y=200:enable='if(gt(t,10),lt(t,20))':fontcolor=white" -af "volume=9" -y -vcodec h264_nvenc o1.mp4
```

### 视频左右拼接到一个屏幕
```shell
ffmpeg -i input.mp4 -i input2.mp4 -filter_complex "[0:v]pad=w=iw*2:h=ih[b];[b][1:v]overlay=x=W/2" -filter_complex amix=inputs=2:duration=first:dropout_transition=2,volume=1 -y out.mp4
```

### 视频合并并转换 多个 码率
```shell
ffmpeg -y -f concat -safe 0 -i video.ts -af volume=9 -s 1280x720 -b 2000k -vcodec h264_nvenc out1.mp4 -af volume=9 -s 1080x720 -b 1200k -vcodec h264_nvenc out2.mp4
```

### 合并 未测试
```shell
ffmpeg -threads 3 -noautorotate  -max_error_rate 0.99 -fflags +genpts  -y   -loglevel info  -probesize 100000000 -analyzeduration 300000000  -user_agent tmpfs_cache -reconnect 1  -f concat -safe -1 -auto_convert 1  -timeout 30000000 -i "video.txt" -map 0:v? -map 0:a? -vcodec copy  -acodec copy -bsf:a aac_adtstoasc  -f mp4 -movflags +faststart  -threads 6  -metadata description="QNY APD MTS" tmp.mp4
```
