# 公历·年号转换器 (Era Converter)

**Chinese Imperial Era ↔ Gregorian Calendar Converter**

A lightweight static web application for converting between Chinese imperial era names and Gregorian calendar years, with support for historical nianhaos (年号) spanning from 140 BCE to 1949 CE.

## Features

- 🔄 **Bidirectional Conversion** – Gregorian ↔ Imperial Era
- 📚 **Comprehensive Database** – 2,000+ historical era names across 200+ dynasties
- 🎯 **Ganzhi Support** – Chinese sexagenary cycle (干支) display
- 🏛️ **Multi-Dynasty Support** – Handles concurrent dynasties and complex transitions
- 📱 **Responsive Design** – Works on desktop, tablet, and mobile
- ⚡ **Zero Dependencies** – Pure vanilla JavaScript
- 🎨 **Traditional Chinese Aesthetic** – Custom font (LXGW WenKai)

## Quick Start

### Local Development

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/era-converter.git
cd era-converter

# Serve with any HTTP server
python -m http.server 8000
# or
npx http-server

# Open browser
# http://localhost:8000
```

### Docker Deployment

```bash
# Using Docker Compose (recommended)
docker compose up -d

# Manual Docker run
docker build -t era-converter:latest .
docker run -d -p 8080:80 era-converter:latest
```

Access at: **http://localhost:8080**

### GitHub Pages

Push to GitHub and enable Pages:
- Go to **Settings** → **Pages**
- Deploy from: `main` branch, `/root` folder
- Access at: `https://YOUR_USERNAME.github.io/era-converter`

## Docker Deployment Options

### Option 1: Local Docker
```bash
docker compose up -d
```

### Option 2: GitHub Container Registry (GHCR)
```bash
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
docker run -d -p 8080:80 ghcr.io/YOUR_USERNAME/era-converter:latest
```

### Option 3: Production Server
```bash
# SSH into server
ssh user@your-server.com

# Pull and run
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
docker run -d --name era-converter -p 80:80 \
  --restart unless-stopped \
  ghcr.io/YOUR_USERNAME/era-converter:latest
```

### Option 4: Kubernetes
```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: era-converter
spec:
  replicas: 2
  selector:
    matchLabels:
      app: era-converter
  template:
    metadata:
      labels:
        app: era-converter
    spec:
      containers:
      - name: web
        image: ghcr.io/YOUR_USERNAME/era-converter:latest
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /index.html
            port: 80
          initialDelaySeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: era-converter
spec:
  selector:
    app: era-converter
  ports:
  - port: 80
  type: LoadBalancer
EOF
```

## CI/CD Pipeline

![Docker Build](https://github.com/YOUR_USERNAME/era-converter/actions/workflows/docker-build.yml/badge.svg)

### Automated Workflows

- **docker-build.yml** – Automatic Docker image build & push to GHCR on every push
- **deploy-pages.yml** – Deploy static site to GitHub Pages

### Push to Deploy

```bash
# Push to main → Docker image builds automatically
git add .
git commit -m "Update content"
git push origin main

# Create release → Automatic version tag
git tag v1.0.0
git push origin v1.0.0
```

Image automatically available at:
- `ghcr.io/YOUR_USERNAME/era-converter:latest`
- `ghcr.io/YOUR_USERNAME/era-converter:v1.0.0`

## Architecture

### Frontend
- **HTML5** – Semantic markup
- **CSS3** – Custom styling with CSS variables
- **Vanilla JavaScript** – No frameworks, ~15KB minified

### Backend (Docker)
- **nginx** – Lightweight web server (~40MB)
- **Gzip Compression** – Auto-compress text assets
- **Long-term Caching** – 1-year cache for static files
- **Security Headers** – X-Frame-Options, X-Content-Type-Options, etc.
- **Health Checks** – Built-in container health monitoring

### Data
- **data.js** – 2,000+ historical era records (70KB)
- **LXGWWenKai-subset.woff2** – Custom font subset (200KB)
- **images-12-logo-red3.png** – Logo asset (18KB)

## File Structure

```
era-converter/
├── index.html                  # Main HTML file
├── data.js                     # Era name database
├── nginx.conf                  # Web server config
├── Dockerfile                  # Container definition
├── docker-compose.yml          # Compose orchestration
├── .dockerignore               # Build exclusions
├── .github/
│   └── workflows/
│       ├── docker-build.yml    # CI/CD build pipeline
│       └── deploy-pages.yml    # GitHub Pages deployment
├── DEPLOYMENT.md               # Docker deployment guide
├── GITHUB_DEPLOYMENT.md        # GitHub/CI-CD guide
└── README.md                   # This file
```

## Performance

- **Image Size** – ~50MB (nginx base + assets)
- **Load Time** – <1s (with caching)
- **Compression** – Gzip enabled (JS/CSS ~70% smaller)
- **Caching** – 1-year TTL for static assets

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Android)

## Data Sources

- 汉—清朝年号：中国台湾"教育部"《国语辞典》附录《中国历代年号表》
- 改元月份：方诗铭《中国历史纪年表》及《资治通鉴》对勘
- 十六国至南北朝：《十国春秋》、《北周史稿》等历史文献

## Contributing

1. Fork repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

This project is licensed under the MIT License – see LICENSE file for details.

Data from publicly available historical records; historical information can be freely cited.

## Deployment Status

| Platform | Status | URL |
|----------|--------|-----|
| GitHub Pages | ✓ Ready | https://YOUR_USERNAME.github.io/era-converter |
| Docker Hub | ○ Optional | docker.io/YOUR_USERNAME/era-converter |
| GHCR | ✓ Active | ghcr.io/YOUR_USERNAME/era-converter |
| Kubernetes | ✓ Ready | See README → Kubernetes section |

## Support

- 📖 [Docker Deployment Guide](DEPLOYMENT.md)
- 🚀 [GitHub CI/CD Setup](GITHUB_DEPLOYMENT.md)
- 🐛 Report issues on GitHub Issues
- 💬 Discussions welcome

## Changelog

### v1.0.0
- Initial release
- Containerized with Docker
- GitHub Actions CI/CD pipeline
- GitHub Pages deployment

---

**Made with ❤️ for Chinese historical research & education**
