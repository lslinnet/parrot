#!/bin/bash
#rm /usr/local/bin/composer
#rm /usr/local/bin/drush
#rm ~/.composer

# Setup composer
if [ -e "/usr/local/bin/composer" ]; then
  # found skipping
  /usr/local/bin/composer self-update
  echo "Composer found! and updated"
else
  curl -sS https://getcomposer.org/installer | php
  if [ -e composer.phar ]; then
  	mv /home/vagrant/composer.phar /usr/local/bin/composer
    ln -s /usr/local/bin/composer /usr/bin/composer
  else
    echo "Failed to download composer"
    exit 1
  fi
  echo "Composer: What are we gonna do today?"
fi

if [ -e "/home/vagrant/.composer/vendor/bin/drush" ]; then
  # found skipping!
  echo "Drush up and running!"
else
  git clone -q https://github.com/drush-ops/drush.git /usr/local/src/drush
  if pushd "/usr/local/src/drush" > /dev/null; then
    git checkout -q 6.5.0  #or whatever version you want.
    ln -s /usr/local/src/drush/drush /usr/bin/drush
    composer install -q
    drush --version    
    popd > /dev/null;
  fi
  echo "Drush: What we do every day, try to take over the world!"
fi

