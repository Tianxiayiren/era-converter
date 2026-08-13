# 公历·年号转换器 (Era Converter)

**Chinese Imperial Era ↔ Gregorian Calendar Converter** — **v1.2.0**

A lightweight static web application for converting between Chinese imperial era names (年号) and Gregorian calendar years. It covers historical nianhaos from **140 BCE (建元) to 1949 CE (民国 38 年)**, including concurrent dynasties, interrupted-then-resumed eras (纪年续接), private in-territory eras, and modern special regimes (太平天国, 伪满洲国, 民国, 洪宪). Currently contains **755 era records across 72 dynasties / regimes**.

## Features

- 🔄 **Bidirectional Conversion** – Gregorian ↔ Imperial Era, both directions
- 📚 **Comprehensive Database** – 755 era records across 72 dynasties / regimes
- 🎯 **Ganzhi Support** – Chinese sexagenary cycle (干支) display for every year
- 🏛️ **Multi-Dynasty Support** – Recorded era names far beyond mainstream dynasties, including Gaochang Kingdom, Balhae Kingdom, Local dynasties of Yunnan such as Nanzhao and Dali...   
- 📜 **Source-Cited Notes** – Era-change notes quote original historical sources with volume (卷次) references (see [Data Sources](#data-sources))
- 🖱️ **Click-to-Jump** – Gregorian → Era results jump directly to the Era → Gregorian conversion with the year pre-filled
- 🔃 **Sortable Table** – Click column headers in the master table to sort by dynasty, emperor, era, start/end year, duration, or era-change month (toggle ascending/descending)
- 📖 **Expandable Notes** – Click an era name in the master table to expand its source-cited era-change note inline (引原文 + 卷次)
- 📱 **Responsive Design** – Works on desktop, tablet, and mobile
- ⚡ **Zero Dependencies** – Pure vanilla JavaScript, no frameworks
- 🎨 **Traditional Chinese Aesthetic** – Custom font (LXGW WenKai 霞鹜文楷)

## Quick Start

### Local Development

```bash
# Clone repository
git clone https://github.com/Tianxiayiren/era-converter.git
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

The site is deployed automatically by GitHub Actions (`pages.yml`) on every push to `main`.
- Live site: **https://tianxiayiren.github.io/era-converter/**

## Docker Deployment Options

### Option 1: Local Docker
```bash
docker compose up -d
```

### Option 2: GitHub Container Registry (GHCR)
```bash
docker pull ghcr.io/tianxiayiren/era-converter:latest
docker run -d -p 8080:80 ghcr.io/tianxiayiren/era-converter:latest
```

### Option 3: Production Server
```bash
# SSH into server
ssh user@your-server.com

# Pull and run
docker pull ghcr.io/tianxiayiren/era-converter:latest
docker run -d --name era-converter -p 80:80 \
  --restart unless-stopped \
  ghcr.io/tianxiayiren/era-converter:latest
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
        image: ghcr.io/tianxiayiren/era-converter:latest
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

![Docker Build](https://github.com/Tianxiayiren/era-converter/actions/workflows/docker-build.yml/badge.svg)

### Automated Workflows

- **docker-build.yml** – Build & push Docker image to GHCR on every push, then run a container health check
- **pages.yml** – Deploy static site to GitHub Pages on every push

### Push to Deploy

```bash
# Push to main → Docker image builds & Pages deploys automatically
git add .
git commit -m "Update content"
git push origin main
```

Image automatically available at:
- `ghcr.io/tianxiayiren/era-converter:latest`

## Architecture

### Frontend
- **HTML5 / CSS3** – Semantic markup, custom styling with CSS variables
- **Vanilla JavaScript** – No frameworks, single self-contained `index.html`

### Backend (Docker)
- **nginx:alpine** – Lightweight web server
- **Gzip Compression** – Auto-compress text assets
- **Long-term Caching** – 1-year cache for static assets
- **Security Headers** – X-Frame-Options, X-Content-Type-Options, etc.
- **Health Check** – `curl`-based container health monitoring (`nginx:alpine` ships curl)

### Data
- **data.js** – 755 era records across 72 dynasties (~73KB)
- **LXGWWenKai-subset.woff2** – Custom font subset (356KB; regenerated 2026-08-11 to cover all CJK characters in notes — 1516 glyphs vs 965 previously)
- **images-12-logo-red3.png** – Logo asset

## File Structure

```
era-converter/
├── index.html                  # Main HTML file (app + notes)
├── data.js                     # Era name database
├── test.js                     # Assertion test suite (966 checks)
├── nginx.conf                  # Web server config
├── Dockerfile                  # Container definition
├── docker-compose.yml          # Compose orchestration
├── .github/
│   └── workflows/
│       ├── docker-build.yml    # GHCR build + health check
│       └── pages.yml           # GitHub Pages deployment
├── DEPLOYMENT.md               # Docker deployment guide
├── GITHUB_DEPLOYMENT.md        # GitHub / CI-CD guide
├── CHECKLIST.md                # Setup checklist
├── QUICKSTART.md               # Quick start guide
└── README.md                   # This file
```

## Data Sources

- **主干数据（汉—清）**：经与中国台湾《重编国语辞典修订本》附录《中国历代年号表》逐条程序化对照核实，该表与方诗铭《中国历史纪年表》口径一致
- **改元年月**：以方诗铭《中国历史纪年表》为基础，参照各正史本纪与《资治通鉴》对勘得出
- **各朝改元 notes 引据**（引原文+卷次）：汉书、后汉书、三国志、晋书、宋书、魏书、梁书、南史、北史、隋书、旧唐书、旧五代史、新五代史、宋史、辽史、金史、元史、明史、清史稿，以及十国春秋、十六国春秋、西夏书事、永历实录（王夫之）、弘光朝偽東宮偽后及黨禍紀略（戴名世）等
- **近代年号**：民国（孙文改元通告）、洪宪（政事堂奉申令）、伪满洲国康德、太平天国（1851 闰八月初一建元）等

## Performance

- **Image Size** – ~55MB (nginx:alpine + assets)
- **Load Time** – <1s (with caching)
- **Compression** – Gzip enabled
- **Caching** – 1-year TTL for static assets

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Android)

## Contributing

1. Fork repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

页面设计、程序代码及数据编排受版权保护，版权所有 © 2026 Jingchao Ye，保留一切权利；未经许可不得用于商业发行或转售。年号、干支、公历年份等历史纪年信息属于客观历史事实，可自由检索与引用。

## Deployment Status

| Platform | Status | URL |
|----------|--------|-----|
| GitHub Pages | ✓ Live | https://tianxiayiren.github.io/era-converter |
| GHCR | ✓ Active | ghcr.io/tianxiayiren/era-converter |
| Docker Hub | — | Not published |

## Support

- 📖 [Docker Deployment Guide](DEPLOYMENT.md)
- 🚀 [GitHub CI/CD Setup](GITHUB_DEPLOYMENT.md)
- 🐛 Report issues on GitHub Issues
- 💬 Discussions welcome

## Changelog

### v1.2.0 (2026-08-12)
- 年号总表支持表头排序：朝代 / 皇帝 / 年号 / 元年 / 末年 / 年数 / 改元各列点击升、降序切换（元年按数值排序、公元前正确前置，空值恒排最后）
- 年号总表可展开改元说明：有说明的行显示「＋」，点击展开/收起该年号引原文 + 卷次的改元详注
- 改元说明逻辑重构为可复用 `noteOf(e)`，「年号 → 公历」与「年号总表」两面板共用，行为与原版完全一致
- 新增南诏隆舜年号：贞明（877–885）、承智（886–888）、大同（889），填补建极（877）至嵯耶（889）间空档（记录数 747 → 750）
- 新增柔然（蠕蠕）年号五条：永康（466–485）、太平（485–492）、太安（492–505）、始平（506–508）、建昌（508–520），据《北史·蠕蠕传》（记录数 750 → 755，政权数 72 → 73）
- 更始政权（刘玄）归入西汉（政权数 73 → 72）；更始帝与年号「更始」均归西汉名下，note 引《东观汉记》卷二十三《载记·刘玄》

### v1.1.0 (2026-08-11)
- 高昌延和纪年续接（延和十八年=619、十九年=620），重光改元月=二月；新增专属 notes
- 吴越天宝延至 908–920（据《十国春秋》卷78），天宝/宝大/宝正专属 notes
- 西夏乾定 note（据张林《略论西夏年号与改元》、《西夏书事》）
- 新增太平天国年号（1851 闰八月初一建元，1864 天京陷落）
- 弘光 note 增补（据戴名世《弘光朝偽東宮偽后及黨禍紀略》）
- 永历改元月改为十月（据王夫之《永历实录》）
- 公历→年号结果栏可点击跳转年号→公历
- 重新生成霞鹜文楷子集字体（`LXGWWenKai-subset.woff2`），覆盖全部页面 CJK 字符：965 → 1516 glyphs（218KB → 356KB）

### v1.0.0
- Initial release
- Containerized with Docker
- GitHub Actions CI/CD pipeline
- GitHub Pages deployment

---

**Made with ❤️ for Chinese historical research & education**
