# 🎯 GitHub Deployment - Action Checklist

## ✅ Setup Completed

- [x] Docker containerization
  - [x] Dockerfile (production-ready nginx)
  - [x] docker-compose.yml (local testing)
  - [x] nginx.conf (optimized config)
  - [x] .dockerignore (build exclusions)

- [x] GitHub Actions CI/CD
  - [x] docker-build.yml (auto build & push)
  - [x] deploy-pages.yml (GitHub Pages)

- [x] Documentation
  - [x] README.md (project overview)
  - [x] QUICKSTART.md (5-minute guide)
  - [x] DEPLOYMENT.md (Docker details)
  - [x] GITHUB_DEPLOYMENT.md (CI/CD details)
  - [x] GITHUB_SETUP_COMPLETE.md (reference)
  - [x] This checklist

- [x] Setup Scripts
  - [x] github-setup.sh (Linux/Mac)
  - [x] github-setup.ps1 (Windows)

---

## 🚀 Your Next Actions (In Order)

### Phase 1: Initialize Git (5 minutes)

- [ ] **Choose your setup method:**
  
  **Option A: Automated (Linux/Mac)**
  ```bash
  bash github-setup.sh
  ```
  
  **Option B: Automated (Windows PowerShell)**
  ```powershell
  .\github-setup.ps1
  ```
  
  **Option C: Manual (All OS)**
  ```bash
  git init
  git add .
  git commit -m "Initial commit: Containerized Era Converter"
  ```

### Phase 2: Create GitHub Repository (2 minutes)

- [ ] Go to https://github.com/new
- [ ] Fill in:
  - [ ] Repository name: `era-converter`
  - [ ] Description: "Chinese Imperial Era ↔ Gregorian Calendar Converter"
  - [ ] Choose: Public (recommended for Pages) or Private
- [ ] Click **Create repository**

### Phase 3: Push Code to GitHub (2 minutes)

- [ ] Set up remote and push:
  ```bash
  git branch -M main
  git remote add origin https://github.com/YOUR_USERNAME/era-converter.git
  git push -u origin main
  ```

### Phase 4: Enable GitHub Actions (2 minutes)

- [ ] Go to your repository → **Actions** tab
- [ ] Verify workflows are visible (should appear automatically)
- [ ] Go to **Settings** → **Actions** → **General**
- [ ] Under "Workflow permissions", select:
  - [ ] **"Read and write permissions"**
- [ ] Click **Save**

### Phase 5: Monitor First Build (5 minutes)

- [ ] Go to **Actions** tab
- [ ] Click on `docker-build` workflow
- [ ] Watch build progress:
  - [ ] Checkout repository
  - [ ] Set up Docker Buildx
  - [ ] Log in to GHCR
  - [ ] Extract metadata
  - [ ] Build and push image
- [ ] Build should complete successfully ✅

### Phase 6: Choose Deployment Method (5-30 minutes)

**Pick ONE deployment option:**

#### Option A: GitHub Pages (Recommended - Easiest)

- [ ] Go to **Settings** → **Pages**
- [ ] Under "Build and deployment":
  - [ ] Source: **Deploy from a branch**
  - [ ] Branch: **main**
  - [ ] Folder: **/ (root)**
- [ ] Click **Save**
- [ ] Wait 2 minutes
- [ ] Access site at: `https://YOUR_USERNAME.github.io/era-converter`

#### Option B: Docker Container (GHCR)

- [ ] Verify image in GHCR:
  - [ ] Go to your repo **Packages** section
  - [ ] Find `era-converter` package
  - [ ] Confirm `latest` tag exists

- [ ] Test locally:
  ```bash
  docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
  docker run -d -p 8080:80 ghcr.io/YOUR_USERNAME/era-converter:latest
  ```
  - [ ] Access: http://localhost:8080

#### Option C: Production Server

- [ ] SSH into your server:
  ```bash
  ssh user@your-server.com
  ```

- [ ] Install Docker (if not already):
  ```bash
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  ```

- [ ] Pull and run image:
  ```bash
  docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
  docker run -d --name era-converter -p 80:80 \
    --restart unless-stopped \
    ghcr.io/YOUR_USERNAME/era-converter:latest
  ```

- [ ] Access: http://your-server.com

#### Option D: Kubernetes

- [ ] Apply manifest (requires Kubernetes cluster):
  ```bash
  kubectl create namespace era-converter
  kubectl apply -f - <<EOF
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: era-converter
    namespace: era-converter
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
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: era-converter
    namespace: era-converter
  spec:
    type: LoadBalancer
    selector:
      app: era-converter
    ports:
    - port: 80
      targetPort: 80
  EOF
  ```

---

## 📊 Verification Checklist

### After Phase 5 (First Build):

- [ ] Workflows completed without errors
- [ ] Image successfully pushed to GHCR
- [ ] Image tags available: `latest`, `main`, `sha-xxxxx`
- [ ] Health checks passed

### After Phase 6 (Deployment):

**If using GitHub Pages:**
- [ ] Site accessible at https://YOUR_USERNAME.github.io/era-converter
- [ ] Page loads without errors
- [ ] All assets load (images, fonts, styles)

**If using Docker:**
- [ ] Container running: `docker ps | grep era-converter`
- [ ] Accessible at http://localhost:8080 (or your server/domain)
- [ ] Health check passing

**If using Kubernetes:**
- [ ] Pods running: `kubectl get pods -n era-converter`
- [ ] Service has external IP: `kubectl get svc -n era-converter`
- [ ] Accessible at the external IP

---

## 🔄 Regular Maintenance

### When you make changes:

```bash
git add .
git commit -m "Update: [description]"
git push origin main
```

✅ Workflow automatically:
- Builds new image
- Pushes to GHCR
- Updates GitHub Pages
- Tags as: `main-[date]`, `latest`

### Create a release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

✅ Workflow automatically tags image as:
- `ghcr.io/YOUR_USERNAME/era-converter:v1.0.0`
- `ghcr.io/YOUR_USERNAME/era-converter:1.0`
- `ghcr.io/YOUR_USERNAME/era-converter:latest`

---

## ⚠️ Troubleshooting

### Build fails at "Log in to Container Registry"

**Cause:** GitHub Actions workflow permissions  
**Fix:**
1. Go to **Settings** → **Actions** → **General**
2. Select **"Read and write permissions"**
3. Click **Save**
4. Retry workflow: Go to **Actions** → Click workflow → **Re-run failed jobs**

### "Cannot pull base image"

**Cause:** Docker Hub rate limiting or network issue  
**Fix:**
- Wait 6 hours (rate limit resets)
- Or retry immediately from Actions tab

### GitHub Pages not updating

**Cause:** Deployment pending  
**Fix:**
- Wait 2 minutes
- Refresh browser
- Check **Settings** → **Pages** → "Your site is live at..."

### "Authentication required" for Docker pull

**Cause:** Image is private  
**Fix:**
```bash
# Create Personal Access Token at: Settings → Developer settings → Personal access tokens → Tokens (classic)
# Scopes: read:packages

docker login ghcr.io -u YOUR_USERNAME -p YOUR_PAT
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
```

---

## 📚 Documentation Files

| File | Purpose | When to Read |
|------|---------|--------------|
| QUICKSTART.md | Fast setup guide | Getting started |
| README.md | Project overview | Understanding project |
| DEPLOYMENT.md | Docker details | Local development |
| GITHUB_DEPLOYMENT.md | CI/CD reference | Setting up workflows |
| GITHUB_SETUP_COMPLETE.md | Full guide | Comprehensive info |
| THIS FILE | Action checklist | Tracking progress |

---

## 🎯 Success Indicators

After completing all phases, you should have:

- ✅ Git repository on GitHub
- ✅ Docker image at GHCR
- ✅ GitHub Actions workflows running
- ✅ Deployed application accessible
- ✅ Automated CI/CD pipeline working
- ✅ Complete documentation

---

## 📞 Support

**If something doesn't work:**

1. Check GitHub Actions logs:
   - Go to **Actions** tab
   - Click workflow run
   - View build output

2. Review documentation:
   - QUICKSTART.md (quick answers)
   - GITHUB_DEPLOYMENT.md (detailed info)

3. Common fixes:
   - Re-run workflow from Actions tab
   - Wait 2-5 minutes for GitHub services
   - Check workflow permissions (Settings → Actions)

---

## 🎉 You're All Set!

Your project is now:
- ✅ Containerized with Docker
- ✅ Automated with GitHub Actions
- ✅ Ready for production deployment
- ✅ Fully documented

**Next action: Run the setup script!**

```bash
# Linux/Mac
bash github-setup.sh

# Windows
.\github-setup.ps1
```

---

**Happy deploying! 🚀**
