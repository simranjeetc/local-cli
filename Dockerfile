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
    build-essential

# Set up oh-my-zsh or any other zsh setup you need
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# Create a non-root user, but do not switch to it yet
RUN useradd -ms /bin/zsh devuser

# Copy the local config folder to the Docker image and ensure the correct ownership
# The --chown option ensures the correct permissions are set during the copy
COPY --chown=devuser:devuser ./neovim-config /home/devuser/.config/nvim

# Install Packer, a plugin manager for Neovim
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /home/devuser/.local/share/nvim/site/pack/packer/start/packer.nvim

# Ensure the correct ownership of Neovim directories
RUN chown -R devuser:devuser /home/devuser/.local/share/nvim/

# Now switch to the non-root user
USER devuser
WORKDIR /home/devuser

# Set the default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Open Neovim to trigger Packer's installation and handle dependencies
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || true

# ENTRYPOINT to drop into zsh shell with the configured Neovim and other tools
ENTRYPOINT ["/bin/zsh"]
