needs() {
  which $1 > /dev/null 2>&1

  if [[ $? -ne 0 ]]; then
    echo "$1 is missing"
    exit 1
  fi
}

needs git

git clone https://github.com/casey/just.git ~/src/just

cd ~/src/just/docs
bash install.sh -- --to ~/bin
