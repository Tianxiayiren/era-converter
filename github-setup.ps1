# GitHub Setup Script for Era Converter (PowerShell)
# Initializes git repository and prepares for GitHub deployment

Write-Host "======================================" -ForegroundColor Green
Write-Host "🚀 Era Converter - GitHub Setup" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Get user input
$GITHUB_USERNAME = Read-Host "Enter your GitHub username"
$REPO_NAME = Read-Host "Enter repository name (default: era-converter)"
if ([string]::IsNullOrEmpty($REPO_NAME)) {
    $REPO_NAME = "era-converter"
}

$REPO_URL = "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

Write-Host ""
Write-Host "📋 Configuration:" -ForegroundColor Cyan
Write-Host "  GitHub Username: $GITHUB_USERNAME"
Write-Host "  Repository: $REPO_NAME"
Write-Host "  Repository URL: $REPO_URL"
Write-Host ""

# Initialize git if not already initialized
if (-not (Test-Path .git)) {
    Write-Host "📦 Initializing git repository..." -ForegroundColor Yellow
    git init
    git config user.name "$GITHUB_USERNAME"
    $EMAIL = Read-Host "Enter your email"
    git config user.email "$EMAIL"
} else {
    Write-Host "✓ Git repository already initialized" -ForegroundColor Green
}

# Add all files
Write-Host "📝 Staging files..." -ForegroundColor Yellow
git add .

# Create initial commit
Write-Host "💾 Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: Containerized Era Converter with GitHub Actions CI/CD" -ErrorAction SilentlyContinue

# Rename branch to main (if needed)
$currentBranch = git branch --show-current
if ($currentBranch -eq "master") {
    Write-Host "🔄 Renaming branch to main..." -ForegroundColor Yellow
    git branch -M main
}

# Add remote
Write-Host "🔗 Adding remote repository..." -ForegroundColor Yellow
git remote remove origin -ErrorAction SilentlyContinue
git remote add origin "$REPO_URL"

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""

Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣  Create repository on GitHub:" -ForegroundColor Yellow
Write-Host "   - Go to https://github.com/new"
Write-Host "   - Repository name: $REPO_NAME"
Write-Host "   - Choose public or private"
Write-Host "   - Click 'Create repository'"
Write-Host ""

Write-Host "2️⃣  Push to GitHub:" -ForegroundColor Yellow
Write-Host "   git push -u origin main" -ForegroundColor Magenta
Write-Host ""

Write-Host "3️⃣  Enable GitHub Actions:" -ForegroundColor Yellow
Write-Host "   - Go to Actions tab on GitHub"
Write-Host "   - Workflows should appear automatically"
Write-Host "   - Check: Settings → Actions → General"
Write-Host "   - Ensure 'Read and write permissions' is selected"
Write-Host ""

Write-Host "4️⃣  Enable GitHub Pages (Optional):" -ForegroundColor Yellow
Write-Host "   - Go to Settings → Pages"
Write-Host "   - Source: Deploy from a branch"
Write-Host "   - Branch: main, folder: / (root)"
Write-Host "   - Access at: https://$GITHUB_USERNAME.github.io/$REPO_NAME"
Write-Host ""

Write-Host "5️⃣  Monitor Deployments:" -ForegroundColor Yellow
Write-Host "   - Go to Actions tab"
Write-Host "   - Watch docker-build workflow run"
Write-Host "   - Image pushed to: ghcr.io/$GITHUB_USERNAME/$REPO_NAME" -ForegroundColor Magenta
Write-Host ""

Write-Host "6️⃣  Pull Docker Image:" -ForegroundColor Yellow
Write-Host "   docker pull ghcr.io/$GITHUB_USERNAME/$REPO_NAME`:latest" -ForegroundColor Magenta
Write-Host ""

Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "   - Deployment: DEPLOYMENT.md"
Write-Host "   - GitHub CI/CD: GITHUB_DEPLOYMENT.md"
Write-Host "   - README: README.md"
Write-Host ""

Write-Host "🎉 Your project is ready for deployment!" -ForegroundColor Green
Write-Host ""
