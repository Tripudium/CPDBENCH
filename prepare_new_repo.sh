#!/bin/bash
#
# Script to prepare CPDBENCH for new GitHub repository
#
# Usage: ./prepare_new_repo.sh [YOUR_GITHUB_USERNAME]
#

set -e

GITHUB_USERNAME="${1:-YOUR_USERNAME}"

echo "🚀 Preparing CPDBENCH for new GitHub repository..."
echo "📝 GitHub Username: $GITHUB_USERNAME"

# Update URL placeholders in files
echo "🔧 Updating GitHub URLs..."

# Update pyproject.toml
sed -i.bak "s/YOUR_USERNAME/$GITHUB_USERNAME/g" pyproject.toml
echo "✅ Updated pyproject.toml"

# Update README.md
sed -i.bak "s/YOUR_USERNAME/$GITHUB_USERNAME/g" README.md
echo "✅ Updated README.md"

# Update MIGRATION.md
sed -i.bak "s/YOUR_USERNAME/$GITHUB_USERNAME/g" MIGRATION.md
echo "✅ Updated MIGRATION.md"

# Clean up backup files
rm -f pyproject.toml.bak README.md.bak MIGRATION.md.bak

# Test uv sync
echo "🧪 Testing uv sync..."
if command -v uv >/dev/null 2>&1; then
    uv sync --all-extras
    echo "✅ uv sync completed successfully"
else
    echo "⚠️  Warning: uv not found. Install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

# Initialize git if not already done
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: CPDBENCH v2.0

- Modernized Python dependency management with uv
- Removed Docker dependencies
- Updated package name from tcpdbench to cpdbench
- Enhanced cross-platform installation documentation
- Improved CI/CD pipeline"
else
    echo "📦 Git repository already initialized"
fi

echo ""
echo "🎉 CPDBENCH preparation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Create new repository on GitHub: https://github.com/new"
echo "   - Repository name: CPDBENCH"
echo "   - Description: Change Point Detection Benchmark - Modern Python Implementation"
echo "   - Make it public"
echo ""
echo "2. Add remote and push:"
echo "   git remote add origin https://github.com/$GITHUB_USERNAME/CPDBENCH.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Update repository settings:"
echo "   - Enable GitHub Actions"
echo "   - Set up branch protection rules"
echo "   - Add topics: change-point-detection, benchmark, time-series, python, uv"
echo ""
echo "🔗 Repository will be available at: https://github.com/$GITHUB_USERNAME/CPDBENCH"