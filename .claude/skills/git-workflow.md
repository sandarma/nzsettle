# Git Workflow Guide

## Branch Strategy

```
main          ← Production (Vercel auto-deploys)
  └── develop ← Active development
       └── feature/xxx ← Feature branches
       └── fix/xxx     ← Bug fix branches
       └── chore/xxx   ← Maintenance tasks
```

## Branch Naming

- `feature/auth-system` — New feature
- `fix/login-redirect` — Bug fix
- `chore/update-dependencies` — Maintenance
- `refactor/listing-schema` — Code refactoring

## Commit Messages

Follow Conventional Commits:

```
feat: add room listing creation form
fix: resolve login redirect issue
docs: update README with setup instructions
style: format code with prettier
refactor: extract S3 upload utility
test: add unit tests for availability system
chore: update dependencies
```

## Workflow

### 1. Start New Work

```bash
# Always start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### 2. Make Changes

```bash
# Stage changes
git add .

# Or stage specific files
git add src/components/ui/Button.tsx

# Commit with descriptive message
git commit -m "feat: add room listing creation form"

# Push to remote
git push origin feature/your-feature-name
```

### 3. Create Pull Request

1. Go to GitHub repository
2. Click "New Pull Request"
3. Select `develop` as base branch
4. Fill out PR template
5. Request review (for now, just self-review)
6. Merge when ready

### 4. Sync with Develop

```bash
# While on your feature branch
git fetch origin
git rebase origin/develop

# If there are conflicts
git add .
git rebase --continue

# Force push (safe on feature branches)
git push --force-with-lease
```

### 5. Merge to Main

```bash
# After feature is complete and tested
git checkout main
git pull origin main
git merge develop
git push origin main

# Vercel will auto-deploy
```

## Commit Best Practices

1. **Commit often** — small, focused commits are easier to review
2. **Write clear messages** — explain what and why, not how
3. **One concern per commit** — don't mix unrelated changes
4. **Test before commit** — ensure code works locally
5. **Never commit** — `.env.local`, `node_modules/`, `.next/`

## What NOT to Commit

```bash
# .gitignore should include:
.env.local
.env
node_modules/
.next/
*.log
.DS_Store
```

## Code Review Checklist

Before merging any PR:

- [ ] Code follows project coding standards
- [ ] No console.log statements left
- [ ] No hardcoded values (use environment variables)
- [ ] TypeScript types are correct
- [ ] Error handling is implemented
- [ ] Mobile responsiveness verified
- [ ] Tested with different user roles
- [ ] Database migrations are reversible
- [ ] Documentation updated if needed

## Emergency Fixes

For critical production issues:

```bash
# Create hotfix branch from main
git checkout main
git checkout -b hotfix/critical-fix

# Make fix
git add .
git commit -m "fix: critical login issue"

# Merge directly to main
git checkout main
git merge hotfix/critical-fix
git push origin main

# Then merge back to develop
git checkout develop
git merge hotfix/critical-fix
git push origin develop

# Delete hotfix branch
git branch -d hotfix/critical-fix
```
