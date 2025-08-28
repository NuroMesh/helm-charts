# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Publishing Helm Charts to GitHub Pages

This guide explains how to publish the event-manager Helm chart to GitHub Pages for public use.

## Prerequisites

1. **GitHub Repository**: You need access to the `Nurol-AI/nurol-ai.github.io` repository
2. **GitHub Pages**: Ensure GitHub Pages is enabled for the repository
3. **Helm**: Install Helm 3.x locally
4. **Git**: Ensure you have git configured with proper credentials

## Setup GitHub Pages Repository

### 1. Enable GitHub Pages

1. Go to your `nurol-ai.github.io` repository settings
2. Navigate to "Pages" in the sidebar
3. Set source to "Deploy from a branch"
4. Select "main" branch and "/ (root)" folder
5. Click "Save"

### 2. Repository Structure

The repository should have this structure:
```
nurol-ai.github.io/
├── README.md
├── charts/
│   ├── index.yaml
│   └── event-manager-0.1.0.tgz
└── .github/
    └── workflows/
        └── publish.yml (optional)
```

## Publishing Methods

### Method 1: Manual Deployment (Recommended for first time)

```bash
# Navigate to the chart directory
cd nurops/event-manager

# Deploy the chart
./scripts/deploy-manual.sh

# Or deploy with specific version
./scripts/deploy-manual.sh 0.2.0
```

### Method 2: Local Build and Push

```bash
# Build for local repository
./scripts/build-repo.sh 0.2.0

# Manually copy files to your repository
cp -r ../../nurol-ai.github.io/charts/* /path/to/your/nurol-ai.github.io/charts/
cp ../../nurol-ai.github.io/README.md /path/to/your/nurol-ai.github.io/

# Commit and push
cd /path/to/your/nurol-ai.github.io
git add .
git commit -m "Add event-manager chart v0.2.0"
git push origin main
```

### Method 3: GitHub Actions (Automatic)

The `.github/workflows/publish-charts.yml` file will automatically:
1. Lint and test charts on every push
2. Package and publish charts when pushing to main
3. Update the repository index
4. Deploy to GitHub Pages

## Verification

### 1. Check Repository Index

Visit: https://nurol-ai.github.io/charts/index.yaml

You should see:
```yaml
apiVersion: v1
entries:
  event-manager:
  - apiVersion: v2
    appVersion: "1.0.0"
    created: "2025-01-XX..."
    description: A Helm chart for Event Manager service...
    digest: abc123...
    name: event-manager
    type: application
    urls:
    - https://nurol-ai.github.io/charts/event-manager-0.1.0.tgz
    version: 0.1.0
```

### 2. Test Installation

```bash
# Add the repository
helm repo add nurol-ai https://nurol-ai.github.io
helm repo update

# Search for charts
helm search repo nurol-ai

# Test installation
helm install test-event-manager nurol-ai/event-manager --dry-run
```

### 3. Verify Chart Package

```bash
# Download and inspect the package
curl -O https://nurol-ai.github.io/charts/event-manager-0.1.0.tgz
tar -tzf event-manager-0.1.0.tgz
```

## Troubleshooting

### Common Issues

1. **404 Error on GitHub Pages**
   - Ensure GitHub Pages is enabled
   - Check that files are in the correct location
   - Wait a few minutes for deployment

2. **Chart Not Found**
   - Verify the index.yaml is updated
   - Check that the chart package exists
   - Ensure URLs in index.yaml are correct

3. **Authentication Issues**
   - Use personal access tokens for git operations
   - Ensure proper repository permissions

### Debug Commands

```bash
# Check chart validity
helm lint .

# Test chart templating
helm template test .

# Validate package
helm package . --dry-run

# Check repository index
helm repo index --help
```

## Version Management

### Updating Chart Version

1. Update `Chart.yaml` version
2. Update `appVersion` if needed
3. Update any version references in documentation
4. Deploy using one of the methods above

### Release Process

```bash
# 1. Update version
sed -i 's/version: .*/version: 0.2.0/' Chart.yaml

# 2. Test the chart
./scripts/test.sh

# 3. Deploy
./scripts/deploy-manual.sh 0.2.0

# 4. Create GitHub release (optional)
git tag v0.2.0
git push origin v0.2.0
```

## Security Considerations

1. **Repository Permissions**: Ensure only authorized users can push to the repository
2. **Chart Signing**: Consider signing charts for production use
3. **Access Control**: Monitor who has access to the repository
4. **Backup**: Keep local copies of chart packages

## Support

For issues with chart publishing:
- Check the troubleshooting section above
- Review GitHub Actions logs if using automated deployment
- Contact the development team for assistance

## License

This publishing process and documentation is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

For commercial use, please contact info@nurol.ai
