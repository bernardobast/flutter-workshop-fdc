# 🚀 CI/CD Workshop - Flutter to Google Cloud Run

Welcome to the CI/CD Workshop! In this hands-on workshop, you'll build a complete CI/CD pipeline to deploy a Flutter web application to Google Cloud Run. Learn industry best practices for automating your software delivery process.

> **Template Credits:** The initial Flutter app template is inspired by the [Flutter Games repository](https://github.com/flutter/games/tree/main/templates/card).

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Part 1: Building Continuous Integration (CI)](#part-1-building-continuous-integration-ci)
- [Part 2: Building Continuous Deployment (CD)](#part-2-building-continuous-deployment-cd)
- [Architecture](#architecture)

## 🎯 Overview

This workshop guides you through creating a production-ready CI/CD pipeline that:
- ✅ Automatically validates code quality on pull requests
- ✅ Runs automated tests to catch bugs early
- ✅ Builds and containerizes your Flutter web app
- ✅ Deploys to Google Cloud Run with zero downtime
- ✅ Uses reusable workflows to follow DRY principles
- ✅ Uses reusable workflows to follow DRY principles

## 📦 Prerequisites

Before starting, ensure you have:
- A GitHub account with access to this repository
- Basic understanding of Git and GitHub workflows
- Familiarity with Flutter/Dart (helpful but not required)
- Access to the provided Google Cloud Project credentials

## 🔧 Part 1: Building Continuous Integration (CI)

Continuous Integration (CI) is your first line of defense against bugs and code quality issues. The CI pipeline automatically validates every pull request before code reaches the main branch.

### What the CI Pipeline Does

The CI pipeline runs five essential checks on every pull request:

1. **`flutter pub get`** - Fetches and installs all dependencies from `pubspec.yaml`
2. **`flutter build web`** - Compiles the Flutter app to web (validates that the build succeeds)
3. **`dart format --output=none --set-exit-if-changed .`** - Enforces consistent code formatting
4. **`flutter analyze`** - Performs static code analysis to catch potential issues
5. **`flutter test`** - Runs all unit and widget tests

### 🎯 Your Task

1. Navigate to `.github/workflows/ci.yml`
2. Implement the CI pipeline following the comments and instructions
3. Create a pull request with your changes
4. Watch the CI pipeline run automatically!
5. Once all checks pass, merge your PR

**Success Criteria:** All CI checks should pass with green checkmarks ✅

---

## 🚀 Part 2: Building Continuous Deployment (CD)

Congratulations on merging your first PR! Now let's automate the deployment process. The CD pipeline triggers automatically when code is merged to the main branch.

### Step 1: Configure GitHub Secrets and Variables

GitHub Secrets and Variables securely store sensitive information and configuration values.

#### Add Secrets
1. Go to **Settings → Secrets and variables → Actions → Repository secrets**
2. Click **New repository secret** and add:
    - **Name:** `GCP_SA_KEY`  
     **Value:** Service account key for Google Cloud authentication
    - **Name:** `GCP_PROJECT_ID`  
     **Value:** Your Google Cloud project ID
    - **Name:** `GCP_ARTIFACT_REGISTRY`  
     **Value:** Name of the Artifact Registry

#### Add Variables
1. Go to **Settings → Secrets and variables → Actions → Variables** tab
2. Click **New repository variable** and add the following:
   - **Name:** `GROUP_NUMBER`  
     **Value:** Your assigned group number (e.g., `1`, `2`, `3`, etc.)

> 💡 **Why GROUP_NUMBER?** Each group needs a unique identifier to avoid conflicts when deploying. This ensures your Docker image and Cloud Run service have unique names like `flutter-workshop-group-1`, `flutter-workshop-group-2`, etc.

### Step 2: Implement the CD Pipeline

Navigate to `.github/workflows/cd.yml` and implement the following steps:

#### 🔐 Step 1: Authentication (DONE ✅)
Authenticate with Google Cloud Platform using the service account credentials:
```yaml
- name: Authenticate with GCP
  uses: google-github-actions/auth@v1
  with:
    credentials_json: ${{ secrets.GCP_SA_KEY }}
```

#### 🏗️ Step 2: Build & Validate (DONE ✅)
Reuse the same build, lint, and test steps from your CI pipeline to ensure code quality.

#### 🐳 Step 3: Build & Push Docker Image
Build a Docker container with your Flutter web app and push it to Google Artifact Registry:

**Docker Image Tag Format:**
```
europe-west3-docker.pkg.dev/${{ secrets.GCP_PROJECT_ID }}/${{ secrets.GCP_ARTIFACT_REGISTRY }}/flutter-app-runner-group-${{ vars.GROUP_NUMBER }}:v$VERSION
```

**Key Commands:**
```bash
# Authenticate Docker with GCP
gcloud auth configure-docker europe-west3-docker.pkg.dev --quiet

# Build and tag the image (includes your group number for uniqueness)
docker build -t $IMAGE .

# Push to Artifact Registry
docker push $IMAGE
```

#### ☁️ Step 4: Deploy to Cloud Run
Deploy your containerized app to Google Cloud Run:

```bash
gcloud run deploy flutter-workshop-group-${{ vars.GROUP_NUMBER }} \
  --image europe-west3-docker.pkg.dev/${{ secrets.GCP_PROJECT_ID }}/${{ secrets.GCP_ARTIFACT_REGISTRY }}/flutter-app-runner-group-${{ vars.GROUP_NUMBER }}:v$VERSION \
  --region us-central1 \
  --allow-unauthenticated
```

### 🎯 Your Task

1. Add the required secrets and variables to your GitHub repository
2. Implement the CD pipeline in `.github/workflows/cd.yml`
3. Commit and push your changes to trigger the CD workflow
4. Monitor the workflow execution in the Actions tab
5. Access your deployed app via the Cloud Run URL!

**Success Criteria:** App successfully deploys and is accessible via the Cloud Run URL 🎉

---

## ️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Developer Workflow                       │
├─────────────────────────────────────────────────────────────┤
│  Create PR ──→ CI Pipeline ──→ Code Review ──→ Merge to Main│
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│                    CD Pipeline (Automated)                   │
├─────────────────────────────────────────────────────────────┤
│  1. Build & Test                                            │
│  2. Build Docker Image                                      │
│  3. Push to Artifact Registry                               │
│  4. Deploy to Cloud Run                                     │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│              🌐 Production (Google Cloud Run)               │
│                  Your Live Flutter App!                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎉 Congratulations!

You've successfully built a complete CI/CD pipeline! You now understand:
- ✅ How CI validates code quality automatically
- ✅ How CD deploys applications to production
- ✅ How to use GitHub Actions and Google Cloud Platform
- ✅ How to containerize and deploy Flutter web apps

### Next Steps

- Explore advanced GitHub Actions features (matrix builds, caching)
- Add end-to-end testing to your pipeline
- Implement blue-green deployments
- Add monitoring and alerting
- Set up staging environments

---

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

**Happy Coding! 🚀**