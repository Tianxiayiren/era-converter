#!/bin/bash

# GitHub Setup Script for Era Converter
# Initializes git repository and prepares for GitHub deployment

set -e

echo "======================================"
echo "🚀 Era Converter - GitHub Setup"
echo "======================================"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Get user input
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter repository name (default: era-converter): " REPO_NAME
REPO_NAME=${REPO_NAME:-era-converter}

REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo ""
echo "📋 Configuration:"
echo "  GitHub Username: $GITHUB_USERNAME"
echo "  Repository: $REPO_NAME"
echo "  Repository URL: $REPO_URL"
echo ""

# Initialize git if not already initialized
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    git config user.name "$GITHUB_USERNAME"
    read -p "Enter your email: " EMAIL
    git config user.email "$EMAIL"
else
    echo "✓ Git repository already initialized"
fi

# Add all files
echo "📝 Staging files..."
git add .

# Create initial commit
echo "💾 Creating initial commit..."
git commit -m "Initial commit: Containerized Era Converter with GitHub Actions CI/CD" || true

# Rename branch to main (if needed)
if git branch -a | grep -q "master"; then
    echo "🔄 Renaming branch to main..."
    git branch -M main
fi

# Add remote
echo "🔗 Adding remote repository..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Create GitHub repository (requires gh CLI)
if command -v gh &> /dev/null; then
    read -p "Do you want to create the repository on GitHub now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🌐 Creating repository on GitHub..."
        gh repo create "$REPO_NAME" --source=. --remote=origin --push
    fi
else
    echo ""
    echo "ℹ️  GitHub CLI not found. To create repository manually:"
    echo "   1. Go to https://github.com/new"
    echo "   2. Repository name: $REPO_NAME"
    echo "   3. Choose public/private"
    echo "   4. Click 'Create repository'"
    echo "   5. Run: git push -u origin main"
fi

echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1️⃣  Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "2️⃣  Enable GitHub Actions:"
echo "   - Go to Actions tab"
echo "   - Workflows should appear automatically"
echo "   - Check workflow permissions in Settings → Actions"
echo ""
echo "3️⃣  Enable GitHub Pages (Optional):"
echo "   - Go to Settings → Pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main, folder: / (root)"
echo "   - Access at: https://$GITHUB_USERNAME.github.io/$REPO_NAME"
echo ""
echo "4️⃣  Monitor Deployments:"
echo "   - Go to Actions tab"
echo "   - Watch docker-build workflow run"
echo "   - Image pushed to ghcr.io/$GITHUB_USERNAME/$REPO_NAME:latest"
echo ""
echo "5️⃣  Pull Docker Image:"
echo "   docker pull ghcr.io/$GITHUB_USERNAME/$REPO_NAME:latest"
echo ""
echo "📚 Documentation:"
echo "   - Deployment: DEPLOYMENT.md"
echo "   - GitHub CI/CD: GITHUB_DEPLOYMENT.md"
echo "   - README: README.md"
echo ""
echo "🎉 Your project is ready for deployment!"
echo ""
