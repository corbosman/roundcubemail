# path
echo -e "\n\nInstalling Dependencies\n\n"

export PATH=$PATH:/usr/xs4all/sbin:/usr/xs4all/bin:/usr/local/bin

# set up a git environment
git config --global user.email "github-bot@xs4all.net"
git config --global user.name "Github Robot"

# get all git based plugins
git submodule init
git submodule update
git submodule foreach git checkout master
git submodule foreach git pull

# get composer based plugins
composer install --no-interaction

# we get the config from the test server
if [ ! -f "config/config.inc.php" ]; then
  cp ../roundcube-test.xs4all.net/config/config.inc.php config/
fi

# managesieve config
if [ ! -f "plugins/managesieve/config.inc.php" ]; then
  cp ../roundcube-dev.xs4all.net/plugins/managesieve/config.inc.php plugins/managesieve
fi

# run cron file to be up to date
RC_CRON_NOW=1 plugins/xs4all_login/storing.cron

# minify
# bin/jsshrink.sh  NOTE: no longer minify, just add minified files to git repo
