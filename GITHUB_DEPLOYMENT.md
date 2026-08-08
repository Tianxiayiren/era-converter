# GitHub Deployment Guide

## Prerequisites

1. **GitHub Repository** – Push this project to GitHub
2. **GitHub Account** – With container registry access (ghcr.io)

## Setup Steps

### 1. Create GitHub Repository

```bash
git init
git add .
git commit -m "Initial commit: containerized era converter"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/era-converter.git
git push -u origin main
```

### 2. Enable GitHub Container Registry (GHCR)

No additional setup needed! GitHub Container Registry is enabled by default. The workflow uses `secrets.GITHUB_TOKEN` automatically.

### 3. Configure GitHub Pages (Optional - for static site hosting)

1. Go to **Settings** → **Pages**
2. Select **Deploy from a branch**
3. Choose **main** branch, **root** folder
4. Save

Your site will be available at: `https://YOUR_USERNAME.github.io/era-converter`

## Workflows Included

### `.github/workflows/docker-build.yml` – Docker Build & Push

**Triggers:**
- ✓ Push to `main` or `develop` branches
- ✓ Any version tag (`v*.*.*`)
- ✓ Pull requests (build only, no push)

**Actions:**
- Builds Docker image with Buildx (faster, multi-platform)
- Pushes to GitHub Container Registry (ghcr.io)
- Runs health checks on built image
- Caches layers for faster rebuilds

**Automatic Tagging:**
- `latest` – for main branch
- `develop` – for develop branch
- `vX.Y.Z` – for version tags
- `main-sha-xxxxx` – for commits

### `.github/workflows/deploy-pages.yml` – GitHub Pages Deployment

**Triggers:**
- ✓ Push to `main` branch
- ✓ Manual trigger (workflow_dispatch)

**Actions:**
- Uploads static files to GitHub Pages
- Enables viewing raw HTML at: `https://YOUR_USERNAME.github.io/era-converter`

## Usage

### Pull Docker Image from GHCR

```bash
# Login (first time only)
echo ${{ secrets.GITHUB_TOKEN }} | docker login ghcr.io -u USERNAME --password-stdin

# Pull latest image
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest

# Run container
docker run -d -p 8080:80 ghcr.io/YOUR_USERNAME/era-converter:latest
```

Replace `YOUR_USERNAME` with your GitHub username.

### Deploy Version Release

1. Create a git tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. Workflow automatically builds and tags image as:
   - `ghcr.io/YOUR_USERNAME/era-converter:v1.0.0`
   - `ghcr.io/YOUR_USERNAME/era-converter:1.0`
   - `ghcr.io/YOUR_USERNAME/era-converter:latest`

3. Create GitHub Release with release notes

### Deploy to Production (Manual)

Option A: **Docker Compose on Server**
```bash
# SSH into server
ssh user@your-server.com

# Pull latest image
docker pull ghcr.io/YOUR_USERNAME/era-converter:latest

# Run with docker-compose
docker compose -f docker-compose.yml up -d
```

Option B: **Kubernetes**
```bash
# Create deployment manifest
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
          periodSeconds: 30
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
    targetPort: 80
  type: LoadBalancer
EOF
```

## CI/CD Pipeline Flow

```
Push to GitHub
    ↓
docker-build.yml triggers
    ↓
1. Build Docker image with Buildx
    ↓
2. Push to ghcr.io
    ↓
3. Run health checks
    ↓
4. Store in GitHub Container Registry
    ↓
Image ready for deployment
```

## View Build Logs

1. Go to **Actions** tab on GitHub
2. Click workflow run
3. View build output and any errors

## Troubleshooting

**Q: "Failed to push image to GHCR"**
- Ensure workflows have "write:packages" permission
- Check: Settings → Actions → General → Workflow permissions

**Q: "Authentication required" when pulling image**
```bash
# Create GitHub Personal Access Token (PAT)
# Go to Settings → Developer settings → Personal access tokens → Tokens (classic)
# Select "read:packages" scope

# Login with PAT
docker login ghcr.io -u YOUR_USERNAME -p YOUR_PAT
```

**Q: "Image pull rate limited"**
- GHCR has higher limits than Docker Hub
- Authenticate to pull images

## Security Best Practices

✓ **Use GitHub Token** – Automatically rotated, scoped to repository  
✓ **Make Image Private** – Go to package settings and set to "private"  
✓ **Branch Protection** – Require PR reviews before merging to main  
✓ **Signed Commits** – Enable commit signing for audit trail  
✓ **Secrets Management** – Store sensitive data in GitHub Secrets

## Next Steps

- [ ] Initialize git repo and push to GitHub
- [ ] Wait for first workflow run to complete
- [ ] Verify image in GHCR packages
- [ ] Deploy to production server or K8s cluster
- [ ] Set up branch protection rules
- [ ] Configure auto-deployment (optional)

## Monitoring & Alerts

Add GitHub status badge to README:
```markdown
![Docker Build](https://github.com/YOUR_USERNAME/era-converter/actions/workflows/docker-build.yml/badge.svg)
```

## Useful GitHub Actions

- **Docker/build-push-action** – Build & push images
- **docker/setup-buildx-action** – Enable advanced Buildx features
- **docker/metadata-action** – Auto-generate image tags & labels
- **actions/deploy-pages@v2** – Deploy to GitHub Pages

---

For issues or questions, check GitHub Actions logs and Docker build output.
