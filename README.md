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
- **LXGWWenKai-subset.woff2** – Custom font subset (381KB; regenerated 2026-08-13 to cover all CJK characters in notes — 1626 glyphs vs 1516 previously)
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

- **主干数据（汉—清）**：经与中国台湾《重编国语辞典修订本》附录《中国历代年号表》逐条程序化对照核实，该表与方诗铭《中国历史纪年表》口径一致。主干王朝的年号起讫年，根据《现代汉语词典》的《我国历代纪元表》校正，略有去取。
- **改元年月**：以方诗铭《中国历史纪年表》为基础，参照各正史本纪与《资治通鉴》对勘得出
- **各朝改元 notes 引据**（引原文 + 卷次），分述如下：
  - **正史本纪/列传/载记**：《汉书》（武帝—平帝诸纪、王莽传）、《后汉书》（光武—献帝诸纪）、《三国志》（魏/蜀/吴书）、《晋书》（帝纪及十六国载记）、《宋书》、《南史》（宋/齐/梁/陈本纪）、《梁书》、《魏书》（道武—出帝诸纪、羯胡石勒传）、《北史》（魏/齐/周本纪、蠕蠕传）、《北齐书》、《周书》、《隋书》（高祖/炀帝/恭帝纪、萧岿/萧琮/越王侗传）、《旧唐书》（高祖—哀帝本纪、则天皇后纪）、《新唐书》（渤海传）、《旧五代史》（诸帝纪、僭伪列传）、《新五代史》（南唐/闽世家）、《辽史》（太祖—天祚帝纪、耶律大石传）、《金史》（太祖—哀宗纪）、《宋史》（太祖—末帝本纪、夏国传）、《元史》（世祖—顺帝纪）、《明史》（太祖—庄烈帝诸纪）、《清史稿》（太祖—宣统本纪）
  - **编年**：《资治通鉴》（含《考异》）、《建康实录》
  - **诏令/政书**：《唐大诏令集》、《宋大诏令集》、《全唐文》（改元诏/赦文）、《宋会要辑稿》
  - **十六国/别史**：《十六国春秋》（西凉录二、北燕录二、夏录三、后燕录、前秦录等）、《东观汉记》（载记·刘玄）、《十国春秋》、《南唐书》、《契丹国志》
  - **地方/杂史**：《滇史》、《云南志略》、《南诏野史》、《西夏书事》、《南明野史》、《甲子会纪》、《唐末泛闻录》、永历实录（王夫之）、弘光朝伪东宫伪后及党祸纪略（戴名世）
  - **出土文献/碑刻**：高昌延和残券、《龙头山渤海王室墓地》、杨温员/真恒/斤囡墓碑、故大师白氏墓碑铭、法句经写本、毕家滩衣物疏、黄氏镇墓文书、《妙法莲华经》残本、《魏受禅碑》、《夏国皇太后新建承天寺瘗佛顶骨舍利轨》
  - **现代论著**：方冬《南诏年号问题补证》（《昆明学院学报》2020年第4期）、张林《略论西夏年号与改元》、梁玉多《渤海国编年史》、魏国忠《渤海史》、张晓舟《渤海顺穆皇后墓志所见延平年号探析》、《高昌史稿·统治篇》、《曲氏高昌国史索隐——从张雄夫妇墓志谈起》（《文物》）
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
- 弘光 note 增补（据戴名世《弘光朝伪东宫伪后及党祸纪略》）
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
