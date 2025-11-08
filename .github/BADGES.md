# GitHub Actions Workflow Badges

Add these badges to your README.md to show workflow status:

## Badge Markdown

```markdown
![CI - Build and Test](https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/CI%20-%20Build%20and%20Test/badge.svg)
![Build and Push Docker Images](https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/Build%20and%20Push%20Docker%20Images/badge.svg)
![Deploy to Production](https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/Deploy%20to%20Production/badge.svg)
```

## Badge HTML (for more control)

```html
<a href="https://github.com/Eursukkul/hello-sekai-shop-microservices/actions/workflows/ci.yml">
  <img src="https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/CI%20-%20Build%20and%20Test/badge.svg" alt="CI Status">
</a>

<a href="https://github.com/Eursukkul/hello-sekai-shop-microservices/actions/workflows/docker-build-push.yml">
  <img src="https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/Build%20and%20Push%20Docker%20Images/badge.svg" alt="Docker Build Status">
</a>
```

## Suggested README.md Addition

Add this section near the top of your README.md:

```markdown
## 🚀 CI/CD Status

![CI - Build and Test](https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/CI%20-%20Build%20and%20Test/badge.svg)
![Build and Push Docker Images](https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/Build%20and%20Push%20Docker%20Images/badge.svg)

## 📦 Quick Deploy

This project uses GitHub Actions for automated CI/CD. See [QUICKSTART.md](QUICKSTART.md) for deployment instructions.

**Deploy Now:**
1. Configure GitHub Secrets ([instructions](.github/DEPLOYMENT.md))
2. Push to `main` branch to trigger builds
3. Use Actions → Deploy to Production for deployment
```

## Other Badge Services

You can also add badges from:

- **Docker Hub**: `https://img.shields.io/docker/pulls/YOUR_USERNAME/hello-sekai-shop`
- **Go Report Card**: `https://goreportcard.com/badge/github.com/Eursukkul/hello-sekai-shop-microservices`
- **License**: `https://img.shields.io/github/license/Eursukkul/hello-sekai-shop-microservices`
- **Go Version**: `https://img.shields.io/github/go-mod/go-version/Eursukkul/hello-sekai-shop-microservices`

Example with shields.io:

```markdown
[![CI Status](https://github.com/Eursukkul/hello-sekai-shop-microservices/workflows/CI%20-%20Build%20and%20Test/badge.svg)](https://github.com/Eursukkul/hello-sekai-shop-microservices/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/YOUR_USERNAME/hello-sekai-shop)](https://hub.docker.com/r/YOUR_USERNAME/hello-sekai-shop)
[![Go Report](https://goreportcard.com/badge/github.com/Eursukkul/hello-sekai-shop-microservices)](https://goreportcard.com/report/github.com/Eursukkul/hello-sekai-shop-microservices)
[![License](https://img.shields.io/github/license/Eursukkul/hello-sekai-shop-microservices)](LICENSE)
```

**Note:** Replace `YOUR_USERNAME` with your actual Docker Hub username and update repository URLs if your GitHub username differs.
