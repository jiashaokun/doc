# FFmpeg 安装步骤 
------
> * 硬件环境：
        ** NVIDIA GPU （Tesla P100）
> * 驱动下载
        ** 显卡驱动[https://www.nvidia.cn/Download/index.aspx?lang=cn] + cuda [https://developer.nvidia.com/cuda-toolkit]
> * 环境设置
        ** pip 10.0.1
        ** Python2.7 + Requests + ffmpeg-4.0

## 安装步骤

### Nvidia_GPU驱动安装
> * 服务器服务商安装
> * 相关资料：[url:https://getpocket.com/a/read/2199372247]

### pip 安装requests
```shell
    pip install requests
```

### 安装 bzip2
```shell
    yum install bzip2
```
### 安装 yasm
```shell
    yum install yasm
    # 或者
    wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    tar zxvf yasm-1.3.0.tar.gz
    cd yasm-1.3.0
    ./configure
    make && make install
```

### 安装 x264
> * [ffmpeg4.0 已经集成了x264的包，所以4.0及一下版本该步骤 (省略)]

```shell
    git clone http://git.videolan.org/git/x264.git
    cd x264/
    ./configure --enable-shared --enable-pthread --enable-pic
    make
    make install
```

### 安装 FFmpeg
```shell
    wge http://www.ffmpeg.org/releases/ffmpeg-4.0.tar.bz2
    tar -xjvf ffmpeg-3.4.2.tar.bz2
    cd ffmpeg-3.4.2
    
    # 必须
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

    # GPU编译安装 [https://developer.nvidia.com/ffmpeg]
    ./configuration: --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64

    make && make install

    export LD_LIBRARY_PATH=/usr/local/cuda/lib64
```



> * 安装依赖包
```shell
vim /etc/ld.so.conf
# 将 /usr/local/lib 直接放到最后一行保存退出
ldconfig

# 执行完毕后 ffmpeg 应该已经没问题了
```

> * 安装完毕设置环境变量 跳过
```shell
vim /etc/profile
# 底部
export PATH="$PATH:/usr/local/ffmpeg/bin"

# 保存退出
# 执行
    source /ect/profile
```

### 错误解决
> * 编译FFmpeg是，若出现如下错误
```shell
ERROR: cuda requested, but not all dependencies are satisfied: ffnvcodec
```
```shell
    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
    cd nv-codec-headers.git
    # make 和 make install 是出现提示不用管
    make
    make install
```
### 执行完毕测试
```shell
ffmpeg -i 64862406_525441_1526891425.mp4  -c:v h264_nvenc -s 1280x720 -b:v 1200k out.mp4
# 出现如下信息
ffmpeg: error while loading shared libraries: libnppig.so.9.2: cannot open shared object file: No such file or directory

export LD_LIBRARY_PATH=/usr/local/cuda/lib64

# 再次执行
ffmpeg -i 64862406_525441_1526891425.mp4  -c:v h264_nvenc -s 1280x720 -b:v 1200k out.mp4
```
