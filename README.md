# 公历·年号转换器 (Era Converter)

**Chinese Imperial Era ↔ Gregorian Calendar Converter** — **v1.5.0**

A lightweight static web application for converting between Chinese imperial era names (年号) and Gregorian calendar years. It covers historical nianhaos from **140 BCE (建元) to 1949 CE (民国 38 年)**, including concurrent dynasties, interrupted-then-resumed eras (纪年续接), private in-territory eras, and modern special regimes (太平天国, 伪满洲国, 民国, 洪宪). Currently contains **755 era records across 72 dynasties / regimes**.

## Features

- 🔄 **Bidirectional Conversion** – Gregorian ↔ Imperial Era, both directions
- 📚 **Comprehensive Database** – 755 era records across 72 dynasties / regimes
- 🎯 **Ganzhi Support** – Chinese sexagenary cycle (干支) display for every year
- 🗓️ **万年历＝按政权分段的历法查询** – 历史朔闰表（前 140–1911）按政权切分：先选政权、再查其年月；分裂时代各政权各用其历法（魏/蜀/吳、南北朝各朝、遼/金、南明/明鄭 等），改历年份保留官网原月名；另有「公历年份 → 并行政权」索引；1900 年起用通行历表
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
- **shuorun-historical.js** – 分政权历史朔闰历表（前 140–1911，23 段/36 政权，逐政权月朔物理日+官网原月名，~240KB）
- **shuorun-terms.js** – 历书节气（前 105–1733，24 气/年；1645 前平气、其后定气，~93KB）
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
- **万年历历史朔闰历表（分政权）**：前 140 – 1911 年按政权分段给出官方历法朔闰（`shuorun-historical.js`），先选政权再查年月；分裂时代各政权各用其历（魏/蜀/吳、北魏/東魏/西魏/北齊/北周、後秦/北涼、遼/金、南明/明鄭 等），政权元年正月朔之前按「承前历表」沿前朝历法。历表整理自 [ytliu0《中國歷代朔閏表》](https://ytliu0.github.io/ChineseCalendar/)（[github.com/ytliu0/ChineseCalendar](https://github.com/ytliu0/ChineseCalendar)，GPL-3.0）各时代页历表，原表据张培瑜、陈美东、薄树人、胡铁珠《中国古代历法》（科学出版社，2008）。原始表 1582-10-15（格里历改革）前以儒略历记录，本工具同以儒略历显示（1582-10 为过渡月），历表按物理日存储，日干支连续。**节气**（`shuorun-terms.js`）同据官网「曆書節氣」：1645 年前平气，1645–1733 历书定气，1734 年起与今法一致。校验：朔闰表月格干支 36,021 格、官网逐日月历表 18 个年份整年对拍、历书节气 17 个年份逐条比对，均 0 不符。历史朔日/闰月属客观史实数据，此处仅作整理与引用。

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

**GNU General Public License v3.0 (GPL-3.0)** — Copyright © 2026 Jingchao Ye

本工具（程序代码与数据编排）为自由软件，依 **GPL-3.0** 发布：可自由使用、修改与再分发，但须保留版权与许可声明、标明修改之处，并以同一许可提供相应源码。许可全文见仓库根目录 [`LICENSE`](LICENSE) 或 <https://www.gnu.org/licenses/gpl-3.0.html>。

### 第三方数据与组件

- **万年历历史朔闰历表**（`shuorun-historical.js`）与**历书节气**（`shuorun-terms.js`）改编自 **ytliu0《中國歷代朔閏表》**（<https://github.com/ytliu0/ChineseCalendar>，Copyright © ytliu0，GPL-3.0）；本站派生文件亦依 GPL-3.0 提供。修改说明见文件头注释：解压原表、换算为物理日 JDN、按政权分段、增补承前历表、改历年份保留原月名。
- **农历历表** `lunar.min.js`：开源项目 **solarlunar**（MIT License，与 GPL 相容）。
- **字体**「霞鹜文楷 LXGW WenKai」：SIL Open Font License 1.1。
- **年号数据**：参照方诗铭《中国历史纪年表》、中国台湾《重编国语辞典修订本》附录《中国历代年号表》等公开资料整理；年号、干支、公历年份等历史纪年信息属客观历史事实，可自由检索与引用。

本项目按"原样"提供，不附带任何明示或默示的担保。

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
### v1.5.0 (2026-09-07)
- **许可改为 GNU GPL-3.0**：整个项目（程序代码与数据编排）以 GPL-3.0 发布；新增仓库根目录 `LICENSE`（GPL-3.0 全文），`index.html` / `data.js` 与两个数据文件加入 GPL 版权与修改声明
- 万年历入口新增「数据来源与许可」声明（上游 ytliu0《中國歷代朔閏表》GPL-3.0 + 本站派生数据文件同许可 + 再分发条件）
- 页脚「版权声明」改写为 GPL-3.0 条款：可自由使用/修改/再分发、须保留声明与标明修改、以同一许可提供源码；并分列 ytliu0 历表数据、solarlunar（MIT）、霞鹜文楷（OFL）等第三方来源
- README「License」小节重写（GPL-3.0 正文 + 第三方数据与组件清单）
### v1.4.2 (2026-09-07)
- **节气改用当时历法口径**：新增 `shuorun-terms.js`（官网源码 `calendricalSolarTerms()` 整理，前 105 – 1733 年 × 24 气），**1645 年前用平气**、1645–1733 用历书定气、1734 年起与今法一致；面板格内节气标记与注记均按此显示（此前一律用现代定气）
- **修复**：政权历法名重复显示（「清·清·時憲曆」→「清·時憲曆」），36 个政权全部清理
- **修复**：儒略历反算函数（`julianDateOfJDN`）公式错误（仅影响校验脚本，不影响页面显示）
- 校验：`shuorun-terms.js` 与官网各年「曆書節氣」逐条对拍 17 个年份（220/221/237/384/500/600/618/700/900/1050/1120/1300/1368/1450/1581/1582/1645）**全部一致**（官网把次年小寒列于当年 12 月，本工具同样显示）
### v1.4.1 (2026-09-07)
- **修复**：官网唐页在武周年份把一个月历年拆成两半（`rowspan` + 夹一行续表头）导致漏月——唐 700 年缺七月～十二月与闰七月（26 个月格）；解析器改为支持「续表头 + 续行合并」
- **新增「承前历表」**：政权元年正月朔之前的日期仍属前朝历法，改按承前历表显示（19 个政权，如清 1645 正月朔 1-28 前依明大统历、唐 618 依隋、明 1368 依元、魏 220 依东汉），并在面板注记说明；覆盖审计已无缺口
- 修复面板注记分支串位（政权视图下误显「未选择政权」天文推算注记）
- **校验**：与官网逐日月历表（index_chinese.html?y=YYYY）做整年逐日对拍 18 个年份（220/221/237/384/500/600/618/700/900/1050/1120/1300/1368/1450/1581/1582/1645/1800），干支与农历日**全部 0 不符**（1582 年为 355 日＝365−10，正好是格里改历略去的 10 天）；朔闰表月格干支校验 36,021 格 0 不符
- 数据文件更新：`shuorun-historical.js`（含 `prev` 承前字段，245 KB）

### v1.4.0 (2026-09-07)
- 万年历重构为**按政权分段**的历法查询：新增 `shuorun-historical.js`（23 段历表 / 36 政权，前 140–1911），先选政权再查年月；分裂时代各政权各用其历法（魏/蜀/吳、北魏/東魏/西魏/北齊/北周、後秦/北涼、遼/金、南明/明鄭 等）
- 保留改历年份的官网原月名（如「正(子)」「後九」），并处理「—」缺月、短行、28 天月等历史改历特例（太初改历、魏景初改历、唐 678/684/689/725/761 改朔等）
- 新增「公历年份 → 并行政权」索引（如 1120 → 辽/金/北宋；237 → 魏/蜀汉/吴）；无历表政权（十六国、十国、渤海、南诏、西夏、太平天国等）不列入
- 数据校验：全部 35,995 个月格的干支与物理日（儒略/格里换算）逐格核对一致（0 不符）
- 深链：`?tab=p4&dyn=明&cal=1582-10`、`?tab=p4&year=1120`

### v1.3.0 (2026-09-07)
- 万年历 1368–1899 年农历接入**历史朔闰历表**（新增 `shuorun-ming-qing.js`）：1368–1644 明大统历、1645–1911 清时宪历，朔日与闰月按官方颁行历法给出，取代此前的纯天文推算参考值；历表据 ytliu0《中國歷代朔閏表》整理（原表据张培瑜等《中国古代历法》），页脚/面板注记/README 均已注明来源与历日基准说明
- 万年历农历层按三段标注：1900–2100「通行历表」、1368–1899「历表」（历史朔闰历表）、其余「推算」（天文参考）
- 万年历支持深链直达：`?tab=p4&cal=年-月`（便于分享与测试）
- 万年历历日基准改为：格里历改革（1582-10-15）之前一律按**儒略历**显示日期（与官网原表、陈垣《二十史朔闰表》等通行史表一致，如 1581-09-28＝万历九年九月初一壬戌）；历表按物理日存储，日干支与农历层不受历日标签影响

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




