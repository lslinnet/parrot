# First lets get all the minor things in place
if ! which brew > /dev/null;
then
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# You might get asked to do this if you haven't so for now
# we might as well do it.
sudo xcodebuild -license

# Updating and everything is just better!
brew update

# Install native apps
brew tap phinze/homebrew-cask
brew install brew-cask

function installcask() {
  brew cask install "${@}" 2> /dev/null
}

installcask virtualbox
installcask vagrant

# Clean up is always nice
brew cleanup

if [ -d ~/workspace/parrot ]
then
  printf '\033[0;33m%s\033[0m%s\n' 'You already have parrot installed.' 'You will need to remove ~/parrot if you want to re-install'
  exit
fi

printf '\033[0;34m%s\033[0m\n' 'Cloning nosh...'
hash git >/dev/null && /usr/bin/env git clone https://github.com/lslinnet/parrot.git ~/workspace/parrot || {
  printf 'git not installed.'
  exit
}

if pushd ~/workspace/parrot > /dev/null;
then
  vagrant plugin install vagrant-cachier
  vagrant up

  popd > /dev/null;
fi

printf '\n \033[0;32m%s\033[0m\n' 'Parrot is now installed and ready to be used.'
