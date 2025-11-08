# Setup script for Hello Sekai Shop microservices deployment
# This script helps initialize production environment files (Windows PowerShell version)

Write-Host "🚀 Hello Sekai Shop - Deployment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running in project root
if (-not (Test-Path "go.mod")) {
    Write-Host "❌ Error: Please run this script from the project root directory" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Step 1: Setting up environment files..." -ForegroundColor Yellow
Write-Host ""

# Create .env for docker-compose
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "✅ Created .env from template" -ForegroundColor Green
    Write-Host "⚠️  Please edit .env and update DOCKER_USERNAME" -ForegroundColor Yellow
} else {
    Write-Host "⏭️  .env already exists, skipping..." -ForegroundColor Gray
}

Write-Host ""

# Setup production environment files
Set-Location "env\prod"

$services = @("auth", "item", "player", "inventory", "payment")

foreach ($service in $services) {
    $envFile = ".env.$service"
    $exampleFile = ".env.$service.example"
    
    if (-not (Test-Path $envFile)) {
        if (Test-Path $exampleFile) {
            Copy-Item $exampleFile $envFile
            Write-Host "✅ Created .env.$service from template" -ForegroundColor Green
        } else {
            Write-Host "❌ Warning: .env.$service.example not found" -ForegroundColor Red
        }
    } else {
        Write-Host "⏭️  .env.$service already exists, skipping..." -ForegroundColor Gray
    }
}

Set-Location "..\..\"

Write-Host ""
Write-Host "📝 Step 2: Configuration checklist" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Please update the following files with actual values:"
Write-Host ""
Write-Host "1. Root .env file:"
Write-Host "   - DOCKER_USERNAME"
Write-Host ""
Write-Host "2. Production environment files (env\prod\):"
Write-Host "   For each .env.* file, update:"
Write-Host "   - DB_URL (MongoDB connection string)"
Write-Host "   - JWT_ACCESS_SECRET_KEY (generate secure random string)"
Write-Host "   - JWT_REFRESH_SECRET_KEY (generate secure random string)"
Write-Host "   - JWT_API_SECRET_KEY (generate secure random string)"
Write-Host "   - KAFKA_URL (your Kafka server)"
Write-Host "   - KAFKA_API_KEY and KAFKA_API_SECRET"
Write-Host "   - GRPC_*_URL (adjust for your network setup)"
Write-Host "   - PAGINATE_*_URL (adjust for your domain)"
Write-Host ""

Write-Host "💡 Quick tip for generating secrets:" -ForegroundColor Cyan
Write-Host "   PowerShell: [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))"
Write-Host "   Or install OpenSSL: openssl rand -base64 32"
Write-Host ""

Write-Host "🔐 Step 3: GitHub Secrets Setup" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Add these secrets to your GitHub repository:"
Write-Host "  Settings → Secrets and variables → Actions → New repository secret"
Write-Host ""
Write-Host "Required secrets:"
Write-Host "  - DOCKER_USERNAME: Your Docker Hub username"
Write-Host "  - DOCKER_PASSWORD: Your Docker Hub access token"
Write-Host ""
Write-Host "Optional (for deployment):"
Write-Host "  - DEPLOY_HOST: Your server IP/hostname"
Write-Host "  - DEPLOY_USER: SSH username"
Write-Host "  - SSH_PRIVATE_KEY: Your SSH private key"
Write-Host ""

Write-Host "✅ Setup script completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📖 Next steps:"
Write-Host "   1. Edit the generated .env files with actual values"
Write-Host "   2. Add secrets to GitHub repository"
Write-Host "   3. Commit and push your changes"
Write-Host "   4. Check GitHub Actions tab for workflow runs"
Write-Host ""
Write-Host "📚 Documentation:"
Write-Host "   - Quick Start: QUICKSTART.md"
Write-Host "   - Full Guide: .github\DEPLOYMENT.md"
Write-Host "   - Summary: .github\SETUP_SUMMARY.md"
Write-Host ""
