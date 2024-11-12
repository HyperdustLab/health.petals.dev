FROM python:3.10-slim-bullseye

# 设置系统代理环境变量
ENV HTTP_PROXY="http://192.168.101.5:7890"
ENV HTTPS_PROXY="http://192.168.101.5:7890"
ENV NO_PROXY="localhost,127.0.0.1,.aliyuncs.com,.npmmirror.com"

# 使用阿里云的 Debian 镜像源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt update && apt install -y libopenblas-dev ninja-build build-essential wget git

# 配置pip使用阿里云镜像源
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config set global.trusted-host mirrors.aliyun.com && \
    pip install --upgrade pip pytest cmake scikit-build setuptools

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt

CMD flask run --host=0.0.0.0 --port=5000