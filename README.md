# Build the container



``` sh
cd ~/path/to/repo

# Needed for dockerfile lsp server
git clone https://github.com/hadolint/hadolint

# With dangling images
docker build --tag lsp-langserver --target alpine-distro .

# Without
DOCKER_BUILDKIT=1 docker build --tag test-con --target alpine-distro .
```
