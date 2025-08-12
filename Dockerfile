FROM node:24-slim

# Global package installation
RUN npm install -g @anthropic-ai/claude-code

# Set working directory
WORKDIR /app

# System updates and Python installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    findutils \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    sudo \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV NODE_ENV=development
ENV SHELL=/bin/bash
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Expose port
EXPOSE 3000

# Set up non-root user
USER node

# Keep container running
CMD ["tail", "-f", "/dev/null"]
