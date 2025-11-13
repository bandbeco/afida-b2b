# Deployment Guide

This application uses **Kamal** for zero-downtime deployments with **GitHub Actions** for continuous deployment.

## Architecture

- **Deployment Tool**: Kamal 2.x
- **Container Registry**: Docker Hub (`bandbeco/afida-b2b`)
- **Application Server**: 100.67.171.22
- **Database Server**: 100.81.232.82 (PostgreSQL 16)
- **Reverse Proxy**: Traefik (managed by Kamal)
- **Domain**: customer.afida.com

## Deployment Workflow

### Automatic Deployment

Every push to `master` that passes CI automatically deploys to production:

1. **CI runs** (lint, security scan, tests)
2. **If CI passes**, deployment workflow triggers
3. **Docker image** is built and pushed to Docker Hub
4. **Kamal** performs zero-downtime rolling deployment
5. **Health checks** verify the deployment

### Manual Deployment

You can also trigger deployments manually:

1. Go to **Actions** → **Deploy** workflow
2. Click **Run workflow**
3. Select `master` branch
4. Click **Run workflow**

## GitHub Secrets Configuration

The following secrets must be configured in GitHub repository settings (`Settings` → `Secrets and variables` → `Actions`):

### Required Secrets

| Secret Name | Description | How to Get |
|------------|-------------|------------|
| `DOCKER_USERNAME` | Docker Hub username | Your Docker Hub account username (e.g., `bandbeco`) |
| `DOCKER_PASSWORD` | Docker Hub access token | Generate at https://hub.docker.com/settings/security |
| `SSH_PRIVATE_KEY` | SSH private key for server access | Generate with `ssh-keygen` and add public key to servers |
| `RAILS_MASTER_KEY` | Rails credentials encryption key | Contents of `config/master.key` |
| `POSTGRES_PASSWORD` | PostgreSQL database password | Database password for user `afida` |
| `DATABASE_URL` | Full database connection URL | `postgres://afida:PASSWORD@100.81.232.82:5432/afida_production` |
| `APP_HOST` | Application host/domain | `customer.afida.com` |

### Setting Up Secrets

#### 1. Docker Hub Credentials

```bash
# Docker Hub username
DOCKER_USERNAME=bandbeco

# Generate access token at https://hub.docker.com/settings/security
# Name: "GitHub Actions Deploy"
# Permissions: Read, Write, Delete
DOCKER_PASSWORD=<your-access-token>
```

#### 2. SSH Private Key

```bash
# Generate a new SSH key pair (if you don't have one)
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_actions_deploy

# Copy the PRIVATE key contents
cat ~/.ssh/github_actions_deploy

# Add the PUBLIC key to your servers
ssh root@100.67.171.22 "echo '$(cat ~/.ssh/github_actions_deploy.pub)' >> ~/.ssh/authorized_keys"
ssh root@100.81.232.82 "echo '$(cat ~/.ssh/github_actions_deploy.pub)' >> ~/.ssh/authorized_keys"
```

**⚠️ Important**: Copy the **entire private key** including the header and footer:
```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

#### 3. Rails Master Key

```bash
# This is already in your local config/master.key
cat config/master.key
```

#### 4. Database Credentials

```bash
# Get the PostgreSQL password from your server or password manager
POSTGRES_PASSWORD=<your-postgres-password>

# Construct the DATABASE_URL
DATABASE_URL=postgres://afida:${POSTGRES_PASSWORD}@100.81.232.82:5432/afida_production
```

#### 5. Application Host

```bash
APP_HOST=customer.afida.com
```

## Local Deployment

### Prerequisites

1. Install Kamal: `gem install kamal`
2. Ensure you have access to the deployment servers via SSH
3. Set up environment variables (see below)

### Environment Setup

Create a `.env.production` file (DO NOT commit this):

```bash
KAMAL_REGISTRY_PASSWORD=<docker-hub-token>
POSTGRES_PASSWORD=<postgres-password>
DATABASE_URL=postgres://afida:<password>@100.81.232.82:5432/afida_production
APP_HOST=customer.afida.com
```

Ensure `config/master.key` exists locally.

### Deploy Commands

```bash
# Full deployment
kamal deploy

# Deploy with verbose output
kamal deploy --verbose

# Deploy specific version/tag
kamal deploy --version=v1.2.3

# Rollback to previous version
kamal rollback <version>
```

### Useful Kamal Commands

```bash
# Check application status
kamal app details

# View logs
kamal app logs
kamal app logs -f  # Follow logs

# Execute Rails console
kamal app exec -i "bin/rails console"

# Execute shell
kamal app exec -i "bash"

# Database console
kamal app exec -i "bin/rails dbconsole"

# Restart application
kamal app restart

# Check server details
kamal server details

# Run database migrations
kamal app exec "bin/rails db:migrate"

# Manage environment variables
kamal env push  # Push updated env vars to servers
```

## Deployment Process Details

### What Happens During Deployment

1. **Pre-build hooks** run locally (if configured)
2. **Docker image** is built with both amd64 and arm64 architectures
3. **Image is pushed** to Docker Hub registry
4. **Pre-deploy hooks** run on servers (if configured)
5. **New container** is started alongside the old one
6. **Health checks** verify the new container is healthy
7. **Traffic switches** to the new container via Traefik
8. **Old container** is stopped and removed
9. **Post-deploy hooks** run (if configured)

### Zero-Downtime Deployment

Kamal achieves zero-downtime by:
- Starting new containers before stopping old ones
- Using Traefik reverse proxy for traffic switching
- Running health checks (`/up` endpoint) before switching traffic
- Maintaining asset bridges between versions

### Health Checks

The application must respond to `GET /up` with HTTP 200 status.
- **Interval**: 3 seconds
- **Timeout**: 30 seconds

## Troubleshooting

### Deployment Fails

1. **Check GitHub Actions logs**: Go to Actions tab and view the failed workflow
2. **Check Kamal version**: Ensure you're using Kamal 2.x (`kamal version`)
3. **Verify secrets**: Ensure all GitHub secrets are correctly set
4. **Check server connectivity**: Ensure GitHub Actions can SSH to your servers

### Common Issues

#### SSH Connection Failed

```bash
# Ensure SSH key is added to servers
ssh root@100.67.171.22 "echo test"

# Check known_hosts
ssh-keyscan -H 100.67.171.22
```

#### Docker Build Failed

```bash
# Test Docker build locally
docker build -t afida-test .

# Check Dockerfile syntax
docker build --check -t afida-test .
```

#### Database Migration Failed

```bash
# Run migrations manually
kamal app exec "bin/rails db:migrate"

# Check database connectivity
kamal app exec "bin/rails runner 'puts ActiveRecord::Base.connection.active?'"
```

#### Application Won't Start

```bash
# Check logs
kamal app logs --since 30m

# Check container status
kamal app details

# Restart application
kamal app restart
```

### Rollback Procedure

If a deployment causes issues:

```bash
# List available versions
kamal app versions

# Rollback to previous version
kamal rollback <previous-version>

# Or manually specify a version
kamal app boot --version=<version>
```

## Monitoring Deployment

### GitHub Actions

- View deployment progress in the **Actions** tab
- Each step shows real-time logs
- Failed steps are highlighted in red

### Application Logs

```bash
# Follow live logs
kamal app logs -f

# View recent logs
kamal app logs --since 1h

# Filter logs by keyword
kamal app logs --grep "ERROR"
```

### Server Monitoring

```bash
# Check container resources
kamal app details

# Check server resources
kamal server details

# SSH into server
ssh root@100.67.171.22
docker ps
docker stats
```

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Rotate credentials** regularly (Docker tokens, SSH keys, database passwords)
3. **Use SSH keys** instead of passwords for server access
4. **Limit SSH key permissions** to deployment-only access
5. **Keep `config/master.key`** secure and never commit it
6. **Use minimal Docker images** to reduce attack surface
7. **Regular security updates** for base images and dependencies

## Maintenance Windows

For database migrations that require downtime:

1. **Schedule maintenance window**
2. **Notify users** in advance
3. **Disable automatic deployments** (remove workflow_run trigger temporarily)
4. **Perform migrations manually**:
   ```bash
   kamal app stop
   kamal app exec "bin/rails db:migrate"
   kamal app start
   ```
5. **Verify application** is working
6. **Re-enable automatic deployments**

## Additional Resources

- [Kamal Documentation](https://kamal-deploy.org/)
- [Kamal GitHub Repository](https://github.com/basecamp/kamal)
- [Docker Hub](https://hub.docker.com/r/bandbeco/afida-b2b)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
