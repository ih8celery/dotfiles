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
  tmux \
  unzip \
  vim-gtk

# Clone down this dotfiles repo to your home directory. Feel free to place
# this anywhere you want, but remember where you've cloned things to.
git clone https://github.com/nickjj/dotfiles ~/dotfiles

# Create symlinks to various dotfiles. If you didn't clone it to ~/dotfiles
# then adjust the ln -fs symlink source (left side) to where you cloned it.
#
# NOTE: The last one is WSL 1 / 2 specific. Don't do it on native Linux / macOS.
mkdir -p ~/.local/bin && mkdir -p ~/.vim/spell \
  && ln -fs ~/dotfiles/.aliases ~/.aliases \
  && ln -fs ~/dotfiles/.bashrc ~/.bashrc \
  && ln -fs ~/dotfiles/.gemrc ~/.gemrc \
  && ln -fs ~/dotfiles/.gitconfig ~/.gitconfig \
  && ln -fs ~/dotfiles/.profile ~/.profile \
  && ln -fs ~/dotfiles/.tmux.conf ~/.tmux.conf \
  && ln -fs ~/dotfiles/.vimrc ~/.vimrc \
  && ln -fs ~/dotfiles/.functions ~/.functions \
  && ln -fs ~/dotfiles/.vim/spell/en.utf-8.add ~/.vim/spell/en.utf-8.add \
  && ln -fs ~/dotfiles/.local/bin/set-theme ~/.local/bin/set-theme \
  && sudo ln -fs ~/dotfiles/etc/wsl.conf /etc/wsl.conf

# Create your own personal ~/.gitconfig.user file. After copying the file,
# you should edit it to have your name and email address so git can use it.
cp ~/dotfiles/.gitconfig.user ~/.gitconfig.user

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

# Install system dependencies for Ruby on Debian / Ubuntu.
#
# Not using Debian or Ubuntu? Here's alternatives for macOS and other Linux distros:
#   https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev \
  libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

# Install Ruby through ASDF.
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.7.1
asdf global ruby 2.7.1

# Install Ansible.
pip3 install --user ansible

# Install AWS CLI v2.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip && sudo ./aws/install && rm awscliv2.zip

# Install Terraform.
curl "https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_amd64.zip" -o "terraform.zip" \
  && unzip terraform.zip && chmod +x terraform \
  && mv terraform ~/.local/bin && rm terraform.zip

vim -c 'PlugInstall' -c 'qa!'

tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server
