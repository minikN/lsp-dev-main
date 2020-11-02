# Build the container

``` sh
cd ~/path/to/repo

# PHP
docker build -t lsp-docker-php -f dockerfiles/PHP .
# SHELL
docker build -t lsp-docker-shell -f dockerfiles/SHELL .
# Dockerfile
docker build -t lsp-docker-dockerfile -f dockerfiles/DOCKERF .
```
