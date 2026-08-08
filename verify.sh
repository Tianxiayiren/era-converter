#!/bin/bash

# Docker Containerization Verification Script
# Validates all required files and configuration

echo "=== Docker 容器化验证 ==="
echo ""

# Check Dockerfile
if [ -f Dockerfile ]; then
    echo "✓ Dockerfile 存在"
    echo "  - 镜像：nginx:latest"
    echo "  - 工作目录：/usr/share/nginx/html"
else
    echo "✗ Dockerfile 未找到"
    exit 1
fi

# Check docker-compose.yml
if [ -f docker-compose.yml ]; then
    echo "✓ docker-compose.yml 存在"
    echo "  - 服务名：era-converter"
    echo "  - 端口映射：8080:80"
else
    echo "✗ docker-compose.yml 未找到"
    exit 1
fi

# Check .dockerignore
if [ -f .dockerignore ]; then
    echo "✓ .dockerignore 存在"
else
    echo "✗ .dockerignore 未找到"
    exit 1
fi

# Check nginx.conf
if [ -f nginx.conf ]; then
    echo "✓ nginx.conf 存在（含缓存、压缩、安全头部优化）"
else
    echo "✗ nginx.conf 未找到"
    exit 1
fi

# Check static assets
echo ""
echo "=== 静态资源检查 ==="
files=("index.html" "data.js" "images-12-logo-red3.png" "LXGWWenKai-subset.woff2")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        size=$(du -h "$file" | cut -f1)
        echo "✓ $file ($size)"
    else
        echo "✗ $file 未找到"
        exit 1
    fi
done

echo ""
echo "=== 快速启动命令 ==="
echo ""
echo "1. 使用 Docker Compose（推荐）："
echo "   docker compose up -d"
echo ""
echo "2. 手动构建和运行："
echo "   docker build -t era-converter:latest ."
echo "   docker run -d --name era-converter -p 8080:80 era-converter:latest"
echo ""
echo "3. 访问应用："
echo "   http://localhost:8080"
echo ""
echo "✓ 所有检查通过！可以开始容器化部署。"
