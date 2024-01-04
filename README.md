# 异星工厂服务器

适合树莓派 4B 使用的异星工厂服务器容器。

## 安装

### 方法一

自行编译。

```bash
git clone https://github.com/LJason77/docker-factorio.git
cd docker-factorio
docker build -t factorio .
```

### 方法二

```bash
docker pull ljason/docker-factorio:latest
```

## 运行

### 创建地图

```bash
# 创建存档目录(将路径换成你的)
mkdir -vp /path/to/factorio/saves
# 创建新地图
docker run --rm -it -v /path/to/factorio/saves:/factorio/saves ljason/docker-factorio:latest --create /factorio/saves/my-save.zip
# 运行服务
docker run -d --restart always --name factorio -v /path/to/factorio/saves:/factorio/saves ljason/docker-factorio:latest --start-server /factorio/saves/my-save.zip
```
