# Risk of Rain 2 专用服务器
雨中冒险2（Risk of Rain 2）docker 服务器

本项目基于镜像 `avivace/ror2server` 进行了优化，支持 Docker Compose 启动，并简化了游戏本体的管理。

### 优化亮点

  * **支持 Docker Compose 启动：** 简化了部署流程，通过一个命令即可启动服务器。
  * **首次运行自动下载游戏本体：** 首次启动容器时会自动下载游戏本体，后续更新需手动执行。

### 使用方式
1.  **构建镜像**
    使用以下命令构建服务镜像：
    ```bash
    docker build -t ror2_server:latest -f Dockerfile .
    ```
    除非你删除了镜像，否则该命令只需执行一次。
2.  **配置与启动：**
    根据您的需求调整 `docker-compose.yaml` 文件中的配置，然后执行以下命令启动服务器：
    ```bash
    docker compose up -d
    ```
3.  **查看日志：**
    使用以下命令查看服务器运行日志：
    ```bash
    docker logs -f ror2server
    ```
4.  **更新游戏本体：**
    当游戏有新版本时，您需要手动更新游戏本体。执行以下命令：
    ```bash
    docker exec -it ror2server /root/ror2-dedicated/entry.sh install
    ```