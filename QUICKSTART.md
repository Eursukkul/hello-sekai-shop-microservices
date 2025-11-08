# 🚀 Quick Start Guide - GitHub Actions Deployment

## Prerequisites

- GitHub repository with this code
- Docker Hub account
- (Optional) A server for deployment (VPS, EC2, or Kubernetes cluster)

## Step 1: Initial Setup (5 minutes)

### 1.1 Create Docker Hub Access Token

1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Name it "github-actions"
4. Copy the token (you'll need it next)

### 1.2 Add GitHub Secrets

Go to your repository → Settings → Secrets and variables → Actions → New repository secret

Add these two secrets:
- **Name:** `DOCKER_USERNAME` | **Value:** Your Docker Hub username
- **Name:** `DOCKER_PASSWORD` | **Value:** Your access token from step 1.1

## Step 2: Test CI Pipeline (2 minutes)

1. Push your code to the `main` branch:
   ```bash
   git add .
   git commit -m "Add GitHub Actions workflows"
   git push origin main
   ```

2. Go to your repository → Actions tab
3. Watch the "CI - Build and Test" workflow run
4. ✅ If it passes, you're good to go!

## Step 3: Build Docker Images (5 minutes)

The Docker build workflow automatically triggers when you push to `main`. Check:

1. Go to Actions tab
2. Look for "Build and Push Docker Images" workflow
3. Once complete, verify images on Docker Hub:
   - https://hub.docker.com/r/YOUR_USERNAME/hello-sekai-shop/tags

You should see tags like:
- `auth-latest`
- `item-latest`
- `player-latest`
- `inventory-latest`
- `payment-latest`

## Step 4: Deploy (Choose Your Method)

### Option A: Quick Local Test

Test the deployment locally first:

```bash
# Copy environment example
cp .env.example .env

# Edit .env with your Docker username
# DOCKER_USERNAME=yourusername

# Copy production env files
cd env/prod
cp .env.auth.example .env.auth
cp .env.item.example .env.item
cp .env.player.example .env.player
cp .env.inventory.example .env.inventory
cp .env.payment.example .env.payment

# Edit each .env file with proper values
# Update DB_URL, secrets, etc.

# Return to project root
cd ../..

# Start services
docker compose -f docker-compose.prod.yml up -d

# Check status
docker compose -f docker-compose.prod.yml ps

# View logs
docker compose -f docker-compose.prod.yml logs -f
```

### Option B: Deploy to Server via SSH

1. **Add deployment secrets** to GitHub:
   ```
   DEPLOY_HOST=your-server-ip-or-domain
   DEPLOY_USER=your-ssh-username
   SSH_PRIVATE_KEY=your-private-key-content
   ```

2. **Prepare your server:**
   ```bash
   # SSH to your server
   ssh user@your-server.com

   # Create deployment directory
   sudo mkdir -p /opt/hello-sekai-shop
   sudo chown $USER:$USER /opt/hello-sekai-shop
   cd /opt/hello-sekai-shop

   # Upload your files
   # - docker-compose.prod.yml
   # - env/prod/.env.* files (with actual values)
   # - .env file
   ```

3. **Deploy from GitHub:**
   - Go to Actions → Deploy to Production
   - Click "Run workflow"
   - Select environment: `production`
   - Enter tag: `latest`
   - Click "Run workflow"

### Option C: Deploy to Kubernetes

1. **Add Kubernetes secret:**
   ```bash
   # Get your kubeconfig
   cat ~/.kube/config | base64 | tr -d '\n'
   
   # Add to GitHub Secrets as KUBE_CONFIG
   ```

2. **Create namespace:**
   ```bash
   kubectl create namespace hello-sekai-shop
   ```

3. **Create deployments and services** (you'll need to create K8s manifests)

4. **Deploy from GitHub Actions**

## Step 5: Verify Deployment

Check if services are running:

```bash
# Health check endpoints
curl http://your-server:1323/health  # Auth
curl http://your-server:1324/health  # Item
curl http://your-server:1325/health  # Player
curl http://your-server:1326/health  # Inventory
curl http://your-server:1327/health  # Payment
```

## Common Issues & Solutions

### ❌ Docker build fails

**Problem:** Go version mismatch
**Solution:** Ensure Dockerfile uses Go 1.21

### ❌ Docker push fails

**Problem:** Invalid credentials
**Solution:** 
1. Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` in GitHub Secrets
2. Make sure token has write permissions
3. Check token isn't expired

### ❌ Tests fail

**Problem:** Missing dependencies or test data
**Solution:**
1. Check test files in `whydoweneedtest/`
2. Ensure test database connections work
3. Review test logs in Actions tab

### ❌ Deployment fails - Can't connect to server

**Problem:** SSH authentication issue
**Solution:**
1. Verify SSH private key is correct
2. Check server IP/hostname
3. Ensure port 22 (or custom SSH port) is open
4. Test SSH manually: `ssh -i your-key user@server`

### ❌ Services won't start

**Problem:** Database connection issues
**Solution:**
1. Check MongoDB is running: `docker ps`
2. Verify DB_URL in env files
3. Check MongoDB credentials match
4. Review logs: `docker logs <container-name>`

## Next Steps

1. **Set up monitoring**: Add health check endpoints
2. **Configure SSL**: Use nginx or traefik as reverse proxy
3. **Set up CI for branches**: Extend workflow to build on PRs
4. **Add integration tests**: Test service-to-service communication
5. **Set up staging environment**: Test before production

## Useful Commands

```bash
# View workflow runs
gh run list

# View specific workflow logs
gh run view <run-id> --log

# Trigger deployment manually
gh workflow run deploy.yml -f environment=production -f tag=latest

# Check Docker images
docker images | grep hello-sekai-shop

# View service logs
docker compose -f docker-compose.prod.yml logs <service-name> -f

# Restart specific service
docker compose -f docker-compose.prod.yml restart <service-name>

# Stop all services
docker compose -f docker-compose.prod.yml down

# Remove all volumes (WARNING: deletes data)
docker compose -f docker-compose.prod.yml down -v
```

## Support

- 📖 Full documentation: `.github/DEPLOYMENT.md`
- 🐛 Issues: Create a GitHub issue
- 💬 Questions: Check GitHub Discussions

---

**Security Reminder:** Never commit actual `.env` files or secrets to Git! Use GitHub Secrets for sensitive data.
