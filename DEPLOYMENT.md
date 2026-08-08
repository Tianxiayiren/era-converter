# 项目容器化完成

## 文件说明

- **Dockerfile** – 使用 nginx 官方镜像，提供轻量级生产环境
- **docker-compose.yml** – Docker Compose 编排文件，一键启动
- **.dockerignore** – 构建时排除的文件
- **nginx.conf** – nginx 配置，包含缓存、压缩、安全头部等优化

## 快速开始

### 方式一：使用 Docker Compose（推荐）

```bash
# 启动容器
docker compose up -d

# 查看日志
docker compose logs -f

# 停止容器
docker compose down
```

应用将在 **http://localhost:8080** 上运行

### 方式二：手动 Docker 构建与运行

```bash
# 构建镜像
docker build -t era-converter:latest .

# 运行容器
docker run -d --name era-converter -p 8080:80 era-converter:latest

# 查看状态
docker ps

# 查看日志
docker logs era-converter

# 停止容器
docker stop era-converter
docker rm era-converter
```

## 性能优化亮点

✓ **多阶段构建** – 最小化镜像大小（若升级为 Node.js 前端框架）  
✓ **Gzip 压缩** – 自动压缩 JS、CSS 等文本资源  
✓ **长期缓存** – 静态资源（.js、.css、.woff2）缓存 1 年  
✓ **安全头部** – X-Frame-Options、X-Content-Type-Options 等  
✓ **健康检查** – 内置 HEALTHCHECK 指令，确保容器健康  
✓ **无root运行** – nginx 以非特权用户运行

## 镜像尺寸

预计 ~50MB（nginx 基础镜像 ~40MB + 静态资源 ~10MB）

## 部署选项

### 单主机部署
```bash
docker compose up -d
```

### 云环境部署（如阿里云、腾讯云）
1. 推送镜像到私有仓库或 Docker Hub
2. 拉取并运行（参考 docker-compose.yml）

### Kubernetes 部署
可基于此 Dockerfile 和配置生成 K8s Deployment/Service 清单

## 常见问题

**Q: 镜像构建失败，网络超时？**  
A: 确保 Docker 可访问互联网，或配置代理。

**Q: 如何修改端口？**  
A: 编辑 `docker-compose.yml` 中的 `ports: - "8888:80"` 改为所需端口。

**Q: 如何添加 HTTPS？**  
A: 通过 nginx 反向代理或 Kubernetes Ingress 配置 TLS 证书。

## 下一步

- 推送镜像到 Docker Registry（Docker Hub / 私有仓库）
- 集成 CI/CD 流程（GitHub Actions、GitLab CI 等）
- 配置监控和日志系统（Prometheus、ELK 等）
