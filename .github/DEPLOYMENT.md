# GitHub Actions CI/CD Setup

This project uses GitHub Actions for automated CI/CD pipeline. The workflows handle building, testing, and deploying the Hello Sekai Shop microservices.

## 📋 Workflows Overview

### 1. CI - Build and Test (`ci.yml`)
**Triggers:** Push and Pull Requests to `main` and `develop` branches

**Jobs:**
- **Test**: Runs unit tests with race detection and generates coverage reports
- **Lint**: Runs golangci-lint for code quality checks
- **Build**: Compiles the Go application and uploads build artifacts

### 2. Build and Push Docker Images (`docker-build-push.yml`)
**Triggers:** 
- Push to `main` branch
- Git tags matching `v*.*.*`
- Manual workflow dispatch

**Features:**
- Builds Docker images for all 5 microservices (auth, item, player, inventory, payment)
- Pushes images to Docker Hub with multiple tags
- Uses Docker layer caching for faster builds
- Parallel builds using matrix strategy

### 3. Deploy to Production (`deploy.yml`)
**Triggers:** Manual workflow dispatch

**Features:**
- Supports multiple deployment targets (Kubernetes, Docker Compose)
- Environment selection (production/staging)
- Health checks after deployment
- Rollback capability

## 🔧 Required GitHub Secrets

### Docker Hub Configuration
```
DOCKER_USERNAME     - Your Docker Hub username
DOCKER_PASSWORD     - Your Docker Hub access token
```

### Deployment Secrets (choose based on your deployment method)

#### For Kubernetes Deployment:
```
KUBE_CONFIG        - Base64 encoded kubeconfig file
```

#### For Docker Compose Deployment (VPS/EC2):
```
DEPLOY_HOST        - Server hostname or IP address
DEPLOY_USER        - SSH username
SSH_PRIVATE_KEY    - SSH private key for authentication
SSH_PORT           - SSH port (optional, defaults to 22)
```

#### For AWS Deployment:
```
AWS_ACCESS_KEY_ID        - AWS access key
AWS_SECRET_ACCESS_KEY    - AWS secret key
AWS_REGION              - AWS region (e.g., us-east-1)
```

## 🚀 Setup Instructions

### 1. Configure Docker Hub

1. Go to your GitHub repository → Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Create a token at https://hub.docker.com/settings/security

### 2. Choose Your Deployment Method

#### Option A: Kubernetes Deployment

1. Get your kubeconfig file:
   ```bash
   cat ~/.kube/config | base64
   ```

2. Add to GitHub Secrets:
   - `KUBE_CONFIG`: The base64 encoded kubeconfig

3. Ensure your Kubernetes cluster has the `hello-sekai-shop` namespace:
   ```bash
   kubectl create namespace hello-sekai-shop
   ```

#### Option B: Docker Compose Deployment (VPS/EC2)

1. Generate SSH key pair (if you don't have one):
   ```bash
   ssh-keygen -t rsa -b 4096 -C "github-actions"
   ```

2. Copy public key to your server:
   ```bash
   ssh-copy-id user@your-server.com
   ```

3. Add to GitHub Secrets:
   - `DEPLOY_HOST`: Your server IP or domain
   - `DEPLOY_USER`: SSH username
   - `SSH_PRIVATE_KEY`: Contents of your private key file
   - `SSH_PORT`: SSH port (optional)

4. On your server, create deployment directory:
   ```bash
   sudo mkdir -p /opt/hello-sekai-shop
   sudo chown $USER:$USER /opt/hello-sekai-shop
   ```

5. Copy your docker-compose files and env files to the server

### 3. Configure Environments in GitHub

1. Go to Settings → Environments
2. Create environments: `production` and `staging`
3. Add protection rules (optional):
   - Required reviewers
   - Wait timer
   - Deployment branches

## 📦 Building and Deploying

### Automatic Builds

Docker images are automatically built and pushed when:
- Code is pushed to `main` branch
- A version tag is created (e.g., `v1.0.0`)

### Manual Deployment

1. Go to Actions tab in your repository
2. Select "Deploy to Production" workflow
3. Click "Run workflow"
4. Choose:
   - Environment (production/staging)
   - Docker image tag (e.g., `latest` or specific commit SHA)
5. Click "Run workflow"

### Create a Release Tag

To trigger a versioned build:

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## 🏗️ Docker Images

All services are pushed to Docker Hub with the following naming convention:

```
<DOCKER_USERNAME>/hello-sekai-shop:<service>-<tag>
```

Examples:
- `yourusername/hello-sekai-shop:auth-latest`
- `yourusername/hello-sekai-shop:item-abc123` (commit SHA)
- `yourusername/hello-sekai-shop:player-v1.0.0` (version tag)

## 🔍 Monitoring Workflows

### View Workflow Status

- Go to the Actions tab in your repository
- Click on any workflow to see details
- View logs, download artifacts, and check test results

### Workflow Badges

Add badges to your README.md:

```markdown
![CI](https://github.com/<username>/<repo>/workflows/CI/badge.svg)
![Docker Build](https://github.com/<username>/<repo>/workflows/Build%20and%20Push%20Docker%20Images/badge.svg)
```

## 🐛 Troubleshooting

### Build Failures

1. Check the workflow logs in Actions tab
2. Verify all secrets are correctly set
3. Ensure Go version matches (1.21)

### Docker Push Failures

1. Verify Docker Hub credentials
2. Check if repository exists and you have write access
3. Ensure you're not hitting Docker Hub rate limits

### Deployment Failures

1. Check deployment logs
2. Verify server connectivity (for SSH deployments)
3. Verify kubeconfig is valid (for Kubernetes deployments)
4. Check environment secrets are properly set

## 📝 Production Environment Files

Example production environment files are located in `env/prod/`:
- `.env.auth.example`
- `.env.item.example`
- `.env.player.example`
- `.env.inventory.example`
- `.env.payment.example`

**Important:** 
1. Copy these files and remove `.example` extension
2. Update all placeholder values with actual production credentials
3. **Never commit actual `.env` files to Git**
4. Use GitHub Secrets or a secrets management service for sensitive values

## 🔒 Security Best Practices

1. **Rotate secrets regularly** - Update Docker Hub tokens and SSH keys periodically
2. **Use environment protection rules** - Require manual approval for production deployments
3. **Enable branch protection** - Protect `main` branch with required reviews
4. **Use least privilege** - Grant minimal permissions to service accounts
5. **Monitor logs** - Regularly check workflow logs for suspicious activity

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Go Testing Documentation](https://golang.org/pkg/testing/)
