# Base Image
FROM ubuntu:latest

# Install necessary tools: zsh, fzf, neovim, git, curl, and any other required dependencies
RUN apt-get update && apt-get install -y \
    zsh \
    fzf \
    neovim \
    git \
    curl \
    bat \
    ripgrep \
    unzip \
    build-essential

# Set up oh-my-zsh or any other zsh setup you need
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# Create a non-root user to avoid permission issues
RUN useradd -ms /bin/zsh devuser
USER devuser
WORKDIR /home/devuser

# Copy the local config folder to the Docker image
COPY ./neovim-config /home/devuser/.config/nvim

# Install Packer, a plugin manager for Neovim
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Set the default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Open Neovim to trigger Packer's installation and dependency handling
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# ENTRYPOINT to drop into zsh shell with the configured Neovim and other tools
ENTRYPOINT ["/bin/zsh"]
