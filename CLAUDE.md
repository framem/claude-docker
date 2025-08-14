# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based development environment for Claude Code. The repository contains Docker configuration files for setting up a containerized development environment with Claude Code pre-installed.

## Development Commands

### Docker Operations

Build the Docker image:
```bash
docker build -t nordwind/claude:latest .
```

Push to Docker Hub:
```bash
docker push nordwind/claude:latest
```

Start the development environment:
```bash
docker-compose up -d
```

Connect to the container:
```bash
docker exec -it code-assistent bash
```

Stop the development environment:
```bash
docker-compose down
```

## Architecture

The project consists of:

- **Dockerfile**: Defines a Node.js 24 slim-based container with Claude Code installed globally, plus Python 3 and essential tools
- **docker-compose.yml**: Orchestrates a single service called `coding-agent` that mounts the current directory to `/app` in the container
- **Claude-Docker.iml**: IntelliJ IDEA module file for IDE integration
- **README.md**: Contains basic Docker build and push commands

## Container Environment

- Base: Node.js 24 slim
- Working directory: `/app`
- Pre-installed: `@anthropic-ai/claude-code`, Python 3, pip, venv, findutils, zsh with powerline10k theme
- Default shell: zsh
- Default editor: nano
- Port exposed: 3000
- Container runs indefinitely with `tail -f /dev/null`
- Current directory is mounted to `/app` for persistent development

## Development Workflow

This repository is designed for containerized development with Claude Code. The typical workflow involves:

1. Building or pulling the Docker image
2. Starting the container with docker-compose
3. Connecting to the container to use Claude Code in the development environment
4. Working on projects mounted from the host filesystem