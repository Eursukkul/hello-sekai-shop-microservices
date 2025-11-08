#!/bin/bash

# Setup script for Hello Sekai Shop microservices deployment
# This script helps initialize production environment files

echo "🚀 Hello Sekai Shop - Deployment Setup"
echo "========================================"
echo ""

# Check if running in project root
if [ ! -f "go.mod" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

echo "📁 Step 1: Setting up environment files..."
echo ""

# Create .env for docker-compose
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "✅ Created .env from template"
    echo "⚠️  Please edit .env and update DOCKER_USERNAME"
else
    echo "⏭️  .env already exists, skipping..."
fi

echo ""

# Setup production environment files
cd env/prod

services=("auth" "item" "player" "inventory" "payment")

for service in "${services[@]}"; do
    if [ ! -f ".env.$service" ]; then
        if [ -f ".env.$service.example" ]; then
            cp ".env.$service.example" ".env.$service"
            echo "✅ Created .env.$service from template"
        else
            echo "❌ Warning: .env.$service.example not found"
        fi
    else
        echo "⏭️  .env.$service already exists, skipping..."
    fi
done

cd ../..

echo ""
echo "📝 Step 2: Configuration checklist"
echo "===================================="
echo ""
echo "Please update the following files with actual values:"
echo ""
echo "1. Root .env file:"
echo "   - DOCKER_USERNAME"
echo ""
echo "2. Production environment files (env/prod/):"
echo "   For each .env.* file, update:"
echo "   - DB_URL (MongoDB connection string)"
echo "   - JWT_ACCESS_SECRET_KEY (generate secure random string)"
echo "   - JWT_REFRESH_SECRET_KEY (generate secure random string)"
echo "   - JWT_API_SECRET_KEY (generate secure random string)"
echo "   - KAFKA_URL (your Kafka server)"
echo "   - KAFKA_API_KEY and KAFKA_API_SECRET"
echo "   - GRPC_*_URL (adjust for your network setup)"
echo "   - PAGINATE_*_URL (adjust for your domain)"
echo ""

echo "💡 Quick tip for generating secrets:"
echo "   Run: openssl rand -base64 32"
echo ""

echo "🔐 Step 3: GitHub Secrets Setup"
echo "==============================="
echo ""
echo "Add these secrets to your GitHub repository:"
echo "  Settings → Secrets and variables → Actions → New repository secret"
echo ""
echo "Required secrets:"
echo "  - DOCKER_USERNAME: Your Docker Hub username"
echo "  - DOCKER_PASSWORD: Your Docker Hub access token"
echo ""
echo "Optional (for deployment):"
echo "  - DEPLOY_HOST: Your server IP/hostname"
echo "  - DEPLOY_USER: SSH username"
echo "  - SSH_PRIVATE_KEY: Your SSH private key"
echo ""

echo "✅ Setup script completed!"
echo ""
echo "📖 Next steps:"
echo "   1. Edit the generated .env files with actual values"
echo "   2. Add secrets to GitHub repository"
echo "   3. Commit and push your changes"
echo "   4. Check GitHub Actions tab for workflow runs"
echo ""
echo "📚 Documentation:"
echo "   - Quick Start: QUICKSTART.md"
echo "   - Full Guide: .github/DEPLOYMENT.md"
echo "   - Summary: .github/SETUP_SUMMARY.md"
echo ""
