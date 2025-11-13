# GitHub Secrets Setup Guide

This guide helps you set up all required GitHub repository secrets for automatic deployment.

## Quick Setup Checklist

- [ ] Docker Hub credentials
- [ ] SSH private key
- [ ] Rails master key
- [ ] PostgreSQL password
- [ ] Database URL
- [ ] Application host

## Step-by-Step Instructions

### 1. Navigate to GitHub Secrets

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** for each secret below

### 2. Add Docker Hub Credentials

#### DOCKER_USERNAME

- **Value**: `bandbeco`
- Click **Add secret**

#### DOCKER_PASSWORD

1. Go to https://hub.docker.com/settings/security
2. Click **New Access Token**
3. Name: `GitHub Actions Deploy`
4. Permissions: **Read, Write, Delete**
5. Click **Generate**
6. Copy the token (you won't see it again!)
7. In GitHub, create secret `DOCKER_PASSWORD` with this token
8. Click **Add secret**

### 3. Add SSH Private Key

#### Generate SSH Key (if needed)

```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_actions_deploy

# View the private key (copy ALL of it, including headers/footers)
cat ~/.ssh/github_actions_deploy
```

#### Add Public Key to Servers

```bash
# App server
ssh root@100.67.171.22 "echo '$(cat ~/.ssh/github_actions_deploy.pub)' >> ~/.ssh/authorized_keys"

# Database server
ssh root@100.81.232.82 "echo '$(cat ~/.ssh/github_actions_deploy.pub)' >> ~/.ssh/authorized_keys"

# Test connection
ssh -i ~/.ssh/github_actions_deploy root@100.67.171.22 "echo 'Connection successful'"
```

#### SSH_PRIVATE_KEY Secret

1. Copy the **entire private key** including headers:
   ```
   -----BEGIN OPENSSH PRIVATE KEY-----
   ...
   -----END OPENSSH PRIVATE KEY-----
   ```
2. In GitHub, create secret `SSH_PRIVATE_KEY`
3. Paste the entire key
4. Click **Add secret**

**⚠️ Important**: Make sure you copy the PRIVATE key, not the .pub file!

### 4. Add Rails Master Key

#### RAILS_MASTER_KEY

```bash
# Display your master key
cat config/master.key
```

1. Copy the key (it's a single line of hex characters)
2. In GitHub, create secret `RAILS_MASTER_KEY`
3. Paste the key
4. Click **Add secret**

**⚠️ Security**: Never commit `config/master.key` to git!

### 5. Add Database Credentials

#### POSTGRES_PASSWORD

1. Get your PostgreSQL password from your server or password manager
2. In GitHub, create secret `POSTGRES_PASSWORD`
3. Paste the password
4. Click **Add secret**

#### DATABASE_URL

Format: `postgres://username:password@host:port/database`

Example: `postgres://afida:your_password_here@100.81.232.82:5432/afida_production`

1. Replace `your_password_here` with your actual password
2. In GitHub, create secret `DATABASE_URL`
3. Paste the complete URL
4. Click **Add secret**

### 6. Add Application Host

#### APP_HOST

- **Value**: `customer.afida.com`
- Click **Add secret**

## Verify Secrets

After adding all secrets, you should see:

✅ **7 secrets configured**:
- DOCKER_USERNAME
- DOCKER_PASSWORD
- SSH_PRIVATE_KEY
- RAILS_MASTER_KEY
- POSTGRES_PASSWORD
- DATABASE_URL
- APP_HOST

## Test Deployment

### Option 1: Manual Workflow Trigger

1. Go to **Actions** → **Deploy**
2. Click **Run workflow**
3. Select `master` branch
4. Click **Run workflow**
5. Watch the deployment progress

### Option 2: Push to Master

1. Make a small change (e.g., update README)
2. Commit and push to `master`
3. CI will run first
4. If CI passes, deployment will trigger automatically

## Troubleshooting

### "Secret not found" Error

- Double-check the secret name matches exactly (case-sensitive)
- Ensure you clicked "Add secret" after pasting the value

### SSH Connection Failed

```bash
# Test SSH connection locally first
ssh -i ~/.ssh/github_actions_deploy root@100.67.171.22

# If fails, check:
# 1. Public key is added to server's authorized_keys
# 2. Private key is correct (entire key with headers)
# 3. Server allows root login (check /etc/ssh/sshd_config)
```

### Docker Login Failed

- Verify `DOCKER_USERNAME` is correct
- Ensure `DOCKER_PASSWORD` is an access token, not your password
- Check token has Read/Write/Delete permissions
- Regenerate token if needed

### Database Connection Failed

```bash
# Test database URL format
# Should be: postgres://USER:PASSWORD@HOST:PORT/DATABASE

# Test connection from app server
ssh root@100.67.171.22
psql "postgres://afida:PASSWORD@100.81.232.82:5432/afida_production" -c "SELECT version();"
```

### Health Check Failed

The application must respond to `GET /up` with HTTP 200.

Check your routes:
```ruby
# config/routes.rb should have:
get "up" => "rails/health#show", as: :rails_health_check
```

## Security Notes

1. **Never share secrets** via email, Slack, or other channels
2. **Rotate secrets** if they're ever exposed
3. **Use password managers** to store production credentials
4. **Limit access** to GitHub repository settings
5. **Audit secret usage** regularly in Actions logs

## Need Help?

- Check `docs/DEPLOYMENT.md` for full deployment guide
- Review GitHub Actions logs for specific error messages
- Test Kamal commands locally before using in CI/CD
- Ensure all servers are accessible and properly configured
