sudo apt-get update && sudo apt-get install -y \
  curl \
  git \
  gnupg \
  htop \
  jq \
  pass \
  pwgen \
  python3-pip \
  ripgrep \
  rsync \
  shellcheck \
  tinyscheme \
  youtube-dl \
  ruby \
  build-essential \
  ansible \
  tldr \
  python \
  tmux \
  vim-nox \
  silversearcher-ag \
  unzip \
  vim-gtk

# Create symlinks to various dotfiles. If you didn't clone it to ~/dotfiles
# then adjust the ln -fs symlink source (left side) to where you cloned it.
#
# NOTE: The last one is WSL 1 / 2 specific. Don't do it on native Linux / macOS.
dot_dir=~/dotfiles/config

mkdir -p ~/.local/bin && mkdir -p ~/.vim/spell \
  && ln -fs $dot_dir/.aliases ~/.aliases \
  && ln -fs $dot_dir/.bashrc ~/.bashrc \
  && ln -fs $dot_dir/.gemrc ~/.gemrc \
  && ln -fs $dot_dir/.gitconfig ~/.gitconfig \
  && ln -fs $dot_dir/.profile ~/.profile \
  && ln -fs $dot_dir/.tmux.conf ~/.tmux.conf \
  && ln -fs $dot_dir/.vimrc ~/.vimrc \
  && ln -fs $dot_dir/.functions ~/.functions \
  && ln -fs $dot_dir/.vim/spell/en.utf-8.add ~/.vim/spell/en.utf-8.add \
  && ln -fs $dot_dir/../bin/set-theme ~/.local/bin/set-theme \
  /&& sudo ln -fs $dot_dir/wsl.conf /etc/wsl.conf

# Install Plug (Vim plugin manager).
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install TPM (Tmux plugin manager).
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install FZF (fuzzy finder on the terminal and used by a Vim plugin).
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# Install ASDF (version manager which I use for non-Dockerized apps).
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8

# Install Node through ASDF. Even if you don't use Node / Webpack / etc., there
# is one Vim plugin (Markdown Preview) that requires Node and Yarn.
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 12.18.3
asdf global nodejs 12.18.3

# Install Yarn.
npm install --global yarn

# Install AWS CLI v2.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip && sudo ./aws/install && rm awscliv2.zip
