FROM node:24

# System updates and dependency installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    findutils \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    sudo \
    nano \
    vim \
    git \
    zsh \
    fzf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R node:node /usr/local/share

# Create workspace, config, and history directories and set permissions
RUN mkdir -p /workspace /home/node/.claude/agents /commandhistory && \
    chown -R node:node /workspace /home/node/.claude /commandhistory && \
    chmod -R u+rwX /commandhistory

# Copy agents files to ~/.claude/agents
COPY --chown=node:node agents/ /home/node/.claude/agents/

# Set working directory
WORKDIR /app

# Set up non-root user
USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR=nano
ENV VISUAL=nano

# Set environment variables
ENV NODE_ENV=development

# Expose port
EXPOSE 3000

# Install Zsh and Oh My Zsh with plugins
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
    -p git \
    -p fzf \
    -a "source /usr/share/fzf/key-bindings.zsh" \
    -a "source /usr/share/fzf/completion.zsh" \
    -a "setopt appendhistory" \
    -a "export HISTFILE=/commandhistory/.zsh_history" \
    -x > /tmp/zsh-install.log 2>&1 || (cat /tmp/zsh-install.log && exit 1)

# Fix permissions for Zsh and Oh My Zsh
RUN chmod -R u+rwX,go-rwx /home/node/.oh-my-zsh /home/node/.zshrc && \
    chown -R node:node /home/node/.oh-my-zsh /home/node/.zshrc

# Global package installation
RUN npm install -g @anthropic-ai/claude-code@latest

# Keep container running
CMD ["tail", "-f", "/dev/null"]
