# Claude Code Docker Image
Ready to start for usage in any project 

## Docker Compose Configuration

Usage in your project/`docker-compose.yml`:

```yaml
services:
  coding-agent:
    image: nordwind/claude:latest
    container_name: code-assistent
    volumes:
      - .:/app
```

## Building own image and publish it

```bash
# Build image
docker build -t nordwind/claude:latest .
```

```bash
# Push to Docker Hub
docker push nordwind/claude:latest
```

