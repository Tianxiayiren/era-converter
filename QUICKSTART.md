# 🚀 Quick Start - GitHub Deployment

## 5-Minute Setup

### Step 1: Initialize Git & Push to GitHub

**On Linux/Mac:**
```bash
bash github-setup.sh
```

**On Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
.\github-setup.ps1
```

Or manually:
```bash
git init
git add .
git commit -m "Initial commit: Containerized Era Converter"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/era-converter.git
git push -u origin main
```

### Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Enter repository name: `era-converter`
3. Choose **Public** (for GitHub Pages) or **Private**
4. Click **Create repository**

### Step 3: Push to GitHub

```bash
git push -u origin main
```

### Step 4: Enable Workflows

1. Go to **Actions** tab on your repository
2. Workflows should appear automatically
3. Click **Settings** → **Actions** → **General**
4. Verify "Workflow permissions" has "Read and write permissions"

### Step 5: Monitor Build

1. Go to **Actions** tab
2. Watch `docker-build` workflow run
3. Once complete, image is available at:
   ```
   ghcr.io/YOUR_USERNAME/era-converter:latest
   ```

---

## Deployment Options After GitHub Setup

### Option A: GitHub Pages (Static Site)

✅ **Automatic** – No configuration needed  
✅ **Free** – No cost  
✅ **URL:** `https://YOUR_USERNAME.github.io/era-converter`

1. Go to **Settings** → **Pages**
2. Select **Deploy from a branch**
3. Choose **main** branch, **root** folder
4. Click **Save**
5. Site available in 1-2 minutes

### Option B: Docker Container from GHCR

**Run locally:**
```bash
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
docker run -d -p 8080:80 ghcr.io/YOUR_USERNAME/era-converter:latest
```

**Run on server:**
```bash
# SSH into server
ssh user@your-server.com

# Run container
docker run -d --name era-converter -p 80:80 \
  --restart unless-stopped \
  ghcr.io/YOUR_USERNAME/era-converter:latest

# Access: http://your-server.com
```

### Option C: Docker Compose on Server

```bash
# SSH into server
ssh user@your-server.com

# Create docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.9'
services:
  web:
    image: ghcr.io/YOUR_USERNAME/era-converter:latest
    ports:
      - "80:80"
    restart: unless-stopped
EOF

# Run
docker compose up -d
```

### Option D: Kubernetes Deployment

```bash
# Replace YOUR_USERNAME with your GitHub username
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
        livenessProbe:
          httpGet:
            path: /index.html
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 30
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "500m"
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

# Check status
kubectl get pods -n era-converter
kubectl get svc -n era-converter
```

---

## Workflows

### 1. docker-build.yml (Automatic Build & Push)

**Triggers:**
- ✅ Push to `main` branch
- ✅ Push to `develop` branch
- ✅ Create version tag (`v1.0.0`)
- ✅ Pull requests (build-only)

**Output:**
- Builds Docker image
- Pushes to `ghcr.io/YOUR_USERNAME/era-converter`
- Tags: `latest`, `main`, `develop`, `vX.Y.Z`, etc.
- Runs health checks

### 2. deploy-pages.yml (GitHub Pages)

**Triggers:**
- ✅ Push to `main` branch
- ✅ Manual trigger (workflow_dispatch)

**Output:**
- Deploys static site to GitHub Pages
- Available at: `https://YOUR_USERNAME.github.io/era-converter`

---

## Create a Release

```bash
# Create version tag
git tag v1.0.0

# Push tag
git push origin v1.0.0

# On GitHub: Go to Releases → Create Release
# - Tag: v1.0.0
# - Title: Version 1.0.0
# - Description: Release notes
```

Image automatically tagged as:
- `ghcr.io/YOUR_USERNAME/era-converter:v1.0.0`
- `ghcr.io/YOUR_USERNAME/era-converter:1.0`
- `ghcr.io/YOUR_USERNAME/era-converter:latest`

---

## Troubleshooting

### ❌ Workflow fails at "Build image"

**Cause:** Cannot fetch base image from Docker Hub  
**Solution:**
- Check internet connection
- Retry: Go to **Actions** → Click workflow → **Re-run failed jobs**

### ❌ "Authentication required" when pulling image

**Cause:** Image is private  
**Solution:**
```bash
# Create Personal Access Token (PAT)
# Settings → Developer settings → Personal access tokens → Tokens (classic)
# Scopes: read:packages

# Login
docker login ghcr.io -u YOUR_USERNAME -p YOUR_PAT

# Pull
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest
```

### ❌ GitHub Pages not updating

**Cause:** Pages deployment takes 1-2 minutes  
**Solution:**
- Wait 2 minutes and refresh
- Check: **Settings** → **Pages** → "Your site is live at..."

### ❌ Workflow permissions error

**Fix:**
1. Go to **Settings** → **Actions** → **General**
2. Under "Workflow permissions"
3. Select **"Read and write permissions"**
4. Click **Save**

---

## Status Badges

Add to README.md:

```markdown
![Docker Build](https://github.com/YOUR_USERNAME/era-converter/actions/workflows/docker-build.yml/badge.svg)
![GitHub Pages](https://github.com/YOUR_USERNAME/era-converter/actions/workflows/deploy-pages.yml/badge.svg)
```

---

## Next Steps

- [ ] Push to GitHub
- [ ] Monitor first workflow run
- [ ] Verify image in GHCR packages
- [ ] Deploy to production
- [ ] Set up monitoring/alerts
- [ ] Configure branch protection rules
- [ ] Enable code scanning (optional)

---

## Support & Documentation

- 📖 Full deployment guide: [DEPLOYMENT.md](DEPLOYMENT.md)
- 🔧 CI/CD details: [GITHUB_DEPLOYMENT.md](GITHUB_DEPLOYMENT.md)
- 📋 Project info: [README.md](README.md)

---

**Happy deploying! 🎉**
