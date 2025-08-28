FROM node:24


# System updates and Python installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    findutils \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    sudo \
    nano \
    vim \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude/agents && \
  chown -R node:node /workspace /home/node/.claude

# Copy agents files to ~/.claude/agents
COPY --chown=node:node agents/ /home/node/.claude/agents/

# Set working directory
WORKDIR /app

# Set up non-root user
USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR=nano
ENV VISUAL=nano


# Set environment variables
ENV NODE_ENV=development
# Expose port
EXPOSE 3000

# Default powerline10k theme
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Global package installation
RUN npm install -g @anthropic-ai/claude-code@latest

# Keep container running
CMD ["tail", "-f", "/dev/null"]
