# Vcnngr Container Images

**"Bitnami Skills, Vcnngr Style"**

Production-ready container images based on Bitnami's excellent work, enhanced with Vcnngr quality standards and automation.

## Overview

This repository provides secure, production-ready container images built on top of Bitnami's foundation. We maintain the high quality and security standards of Bitnami containers while adding:

- **Enhanced CI/CD**: Jenkins pipelines with quality gates
- **Code Quality**: Shellcheck and SonarQube analysis
- **Security**: Automated Trivy scanning with retry logic
- **Minimal Base**: vcnngr/minideb for reduced attack surface
- **Non-root**: All containers run as unprivileged user (UID 1001)
- **Kubernetes-native**: Built and tested on Kubernetes

## Available Images

| Image | Version | Base | Status |
|-------|---------|------|--------|
| [minideb](https://hub.docker.com/r/vcnngr/minideb) | bookworm, trixie | Debian minimal | ✅ Production |
| [apache](https://hub.docker.com/r/vcnngr/apache) | 2.4 | vcnngr/minideb:bookworm | ✅ Production |
| nginx | 1.29 | vcnngr/minideb:bookworm | 🚧 Coming Soon |
| redis | 7.x | vcnngr/minideb:bookworm | 🚧 Coming Soon |
| postgresql | 16.x | vcnngr/minideb:bookworm | 🚧 Coming Soon |

## Quick Start

```bash
# Pull an image
docker pull vcnngr/apache:latest

# Run Apache HTTP Server
docker run -d -p 8080:8080 --name my-apache vcnngr/apache:latest

# Test
curl http://localhost:8080

# View logs
docker logs my-apache

# Stop and remove
docker stop my-apache && docker rm my-apache
```

## Repository Structure

```
containers/
├── minideb/              # Minimal Debian base image
│   ├── mkimage           # Base image creation script
│   ├── import            # Import and tag script
│   └── Jenkinsfile       # CI/CD pipeline
│
├── apache/               # Apache HTTP Server
│   ├── 2.4/
│   │   └── debian-12/
│   │       ├── Dockerfile
│   │       ├── prebuildfs/    # Pre-build scripts
│   │       └── rootfs/        # Runtime scripts
│   ├── Jenkinsfile            # CI/CD pipeline
│   └── README.md
│
└── [other containers...]
```

## Build Pipeline Features

Every container image is built through a comprehensive pipeline:

### Code Quality
- **Shellcheck**: Linting for all shell scripts
- **SonarQube**: Code quality analysis and technical debt tracking
- **Quality Gates**: Automated checks before deployment

### Security
- **Trivy**: Vulnerability scanning (HIGH/CRITICAL)
- **Non-root execution**: UID 1001 (unprivileged)
- **Minimal base**: Reduced attack surface with minideb
- **Security updates**: Automated scanning for new CVEs

### Testing
- **Functional tests**: Container startup and basic operations
- **Metadata validation**: OCI labels and configuration
- **Port verification**: Exposed ports check
- **User verification**: Non-root user enforcement

### Automation
- **Multi-arch support**: amd64, arm64 (where applicable)
- **Automated tagging**: Version, major, latest tags
- **Build reports**: JSON metadata for each build
- **Artifact archival**: Security reports and build logs

## Jenkins Integration

All images are built on Kubernetes using Jenkins with:

```groovy
// Quality checks
stage('Code Quality') {
    parallel {
        stage('Shellcheck')
        stage('SonarQube')
    }
}

// Security scanning
stage('Security Scan') {
    // Trivy with retry logic
}

// Build and test
stage('Build Image')
stage('Test Image')
stage('Push to Registry')
```

### Required Jenkins Credentials
- `dockerhub-vcnngr`: DockerHub username and token
- `sonarqube-token`: SonarQube authentication token

## Development

### Prerequisites
- Python 3.9+
- Docker or Buildah
- Jenkins on Kubernetes (for CI/CD)
- Access to vcnngr DockerHub organization

### Local Build Example

```bash
# Clone the repository
git clone https://github.com/vcnngr/containers.git
cd containers/apache/2.4/debian-12

# Build locally with Docker
docker build -t vcnngr/apache:test .

# Or with Buildah
buildah bud -t vcnngr/apache:test .

# Test
docker run -d -p 8080:8080 vcnngr/apache:test
curl http://localhost:8080
```

### Adding a New Container

1. **Analyze Bitnami source**
```bash
python filtered_analyzer.py bitnami-containers --containers nginx --output nginx_analysis.json
```

2. **Rebrand to Vcnngr**
```bash
python rebranding_script.py nginx bitnami-containers vcnngr-containers --execute
```

3. **Generate Jenkinsfile**
```bash
python jenkins_generator.py nginx_analysis.json
cp generated_jenkinsfiles/Jenkinsfile.nginx nginx/Jenkinsfile
```

4. **Commit and push**
```bash
git add nginx/
git commit -m "Add nginx container"
git push origin main
```

5. **Configure Jenkins job** and trigger first build

## Differences from Bitnami

While we maintain compatibility with Bitnami containers, we add:

| Feature | Bitnami | Vcnngr |
|---------|---------|--------|
| Base Image | bitnami/minideb | vcnngr/minideb |
| CI/CD | GitHub Actions | Jenkins on K8s |
| Code Quality | - | Shellcheck + SonarQube |
| Security Scan | Basic | Trivy with retry logic |
| Quality Gates | - | Automated enforcement |
| Build Reports | - | JSON metadata + artifacts |

## Security

### Vulnerability Reporting
If you discover a security vulnerability, please email: security@vcnngr.io

### Security Features
- All containers run as non-root (UID 1001)
- Regular security scanning with Trivy
- Automated updates for security patches
- Minimal base image (vcnngr/minideb)
- OCI labels for transparency

## Monitoring & Updates

### Automated Update Detection
We monitor Bitnami releases for:
- New versions
- Security patches
- Critical updates

Configured through:
- Jenkins scheduled jobs (nightly)
- GitHub Actions watchers (optional)
- Manual triggers available

## Support

### Resources
- **Documentation**: See individual container READMEs
- **Issues**: https://github.com/vcnngr/containers/issues
- **Docker Hub**: https://hub.docker.com/u/vcnngr
- **Bitnami Source**: https://github.com/bitnami/containers

### Getting Help
1. Check the container-specific README
2. Review existing issues on GitHub
3. Create a new issue with:
   - Container name and version
   - Error messages or logs
   - Steps to reproduce

## Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Contribution Guidelines
- Maintain compatibility with Bitnami patterns
- Include appropriate tests
- Update documentation
- Follow existing code style
- Add Jenkinsfile for new containers

## Acknowledgments

This project is based on the excellent work of Bitnami/Broadcom. We maintain the same high standards while adding our own enhancements.

**Original work**: https://github.com/bitnami/containers  
**License**: Apache 2.0

## License

Copyright © 2025 Vcnngr  
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---

**Built with care by the Vcnngr team**  
*Bitnami Skills, Vcnngr Style*
