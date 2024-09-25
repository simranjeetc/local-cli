# Use a lightweight base image like Ubuntu or Alpine
FROM ubuntu:latest

# Install necessary tools: zsh, fzf, neovim, git, curl, and other required dependencies
RUN apt-get update && apt-get install -y \
    zsh \
    fzf \
    neovim \
    git \
    curl \
    bat \
    ripgrep \
    unzip \
    build-essential \
    lua5.4 \
    luarocks

# Set up oh-my-zsh or any other zsh setup you need
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# Create a non-root user, but do not switch to it yet
RUN useradd -ms /bin/zsh devuser

# Switch to non-root user and set up the environment
USER devuser
WORKDIR /home/devuser

# Install lazy.nvim (plugin manager) and LazyVim
RUN git clone https://github.com/folke/lazy.nvim.git ~/.config/nvim/lua/lazy.nvim

# Check if nvim directory exists, clone if it doesn't, or clean it if it does
RUN if [ -d ~/.config/nvim ]; then \
    rm -rf ~/.config/nvim; \
  fi && git clone https://github.com/LazyVim/starter ~/.config/nvim

# Copy custom plugins and settings (coding.lua and init.lua)
COPY ./coding.lua /home/devuser/.config/nvim/lua/plugins/coding.lua
COPY ./init.lua /home/devuser/.config/nvim/lua/plugins/init.lua

# Set default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Install Neovim plugins
RUN nvim --headless "+Lazy sync" +qall

# ENTRYPOINT to drop into zsh shell with the configured Neovim and other tools
CMD ["/bin/zsh"]
