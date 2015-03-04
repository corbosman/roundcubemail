#!/bin/sh

echo -e "\n\nInstalling Dependencies\n\n"

# path
export PATH=$PATH:/usr/xs4all/sbin:/usr/xs4all/bin:/usr/local/bin

# get all git based plugins
git submodule init
git submodule update
git submodule foreach git checkout master
git submodule foreach git pull

# get composer based plugins
composer install --no-interaction

# we get the config from the test server
if [ ! -f "config/config.inc.php" ]; then
  cp ../configs/config.inc.php config/
fi

# managesieve config
if [ ! -f "plugins/managesieve/config.inc.php" ]; then
  cp ../configs/managesieve.inc.php plugins/managesieve/config.inc.php
fi

# run cron file to be up to date
RC_CRON_NOW=1 plugins/xs4all_login/storing.cron

# minify
# bin/jsshrink.sh  NOTE: no longer minify, just add minified files to git repo
