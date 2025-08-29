# Helm Chart Scripts
This directory contains centralized scripts for managing Helm charts in the Nurol AI repository.

## Available Scripts

### `helm-test.sh` - Chart Validation
Validates Helm charts by running template tests.

```bash
# Test all charts
./scripts/helm-test.sh

# Test specific chart
./scripts/helm-test.sh nurops/event-manager

# Test with verbose output
./scripts/helm-test.sh -v nurops/event-manager
```

### `helm-lint.sh` - Chart Linting and Validation
Performs comprehensive linting and validation of Helm charts.

```bash
# Lint current directory
./scripts/helm-lint.sh

# Lint specific chart
./scripts/helm-lint.sh nurops/event-manager

# Lint with verbose output
./scripts/helm-lint.sh -v nurops/event-manager
```

### `helm-package.sh` - Chart Packaging
Creates Helm packages and repository indexes.

```bash
# Package current directory
./scripts/helm-package.sh

# Package specific chart
./scripts/helm-package.sh nurops/event-manager

# Package with specific version
./scripts/helm-package.sh nurops/event-manager 1.0.0

# Package to custom destination
./scripts/helm-package.sh -d /tmp/packages nurops/event-manager
```

### `helm-deploy.sh` - Chart Deployment
Deploys charts to GitHub Pages repository.

```bash
# Deploy current directory
./scripts/helm-deploy.sh

# Deploy specific chart
./scripts/helm-deploy.sh nurops/event-manager

# Deploy with specific version
./scripts/helm-deploy.sh nurops/event-manager 1.0.0

# Deploy without pushing
./scripts/helm-deploy.sh --no-push nurops/event-manager
```

## Common Workflow

### Development Workflow
1. **Test your chart**: `./scripts/helm-test.sh nurops/your-chart`
2. **Lint your chart**: `./scripts/helm-lint.sh nurops/your-chart`
3. **Package your chart**: `./scripts/helm-package.sh nurops/your-chart`

### Release Workflow
1. **Update version**: Edit `Chart.yaml` or use version parameter
2. **Test thoroughly**: `./scripts/helm-test.sh nurops/your-chart`
3. **Package**: `./scripts/helm-package.sh nurops/your-chart 1.0.0`
4. **Deploy**: `./scripts/helm-deploy.sh nurops/your-chart 1.0.0`

## Script Features

- **Cross-platform**: Works on Linux, macOS, and Windows (with WSL)
- **Error handling**: Comprehensive error checking and validation
- **Flexible**: Supports multiple chart directories and custom configurations
- **Documented**: Each script includes help and usage examples
- **Consistent**: Standardized interface across all scripts

## Requirements

- **Helm**: Version 3.x or later
- **kubectl**: For validation (optional)
- **Git**: For deployment scripts
- **Bash**: All scripts require bash shell

## Directory Structure

```
helm-charts/
├── scripts/
│   ├── helm-test.sh      # Chart validation
│   ├── helm-lint.sh      # Chart linting
│   ├── helm-package.sh   # Chart packaging
│   ├── helm-deploy.sh    # Chart deployment
│   └── README.md         # This file
├── nurops/
│   ├── event-manager/    # Event Manager chart
│   └── ...               # Other charts
└── packages/             # Generated packages
```

## Contributing

When adding new scripts:

1. Follow the existing naming convention: `helm-{action}.sh`
2. Include proper copyright headers
3. Add comprehensive help and usage documentation
4. Include error handling and validation
5. Test with multiple chart types
6. Update this README with usage examples

## License

All scripts are licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

For commercial use, please contact info@nurol.ai  

**Copyright (c) 2025 Nurol, Inc. (nurol.ai)**
