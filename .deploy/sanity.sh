#!/bin/bash

echo -e "\n\n\e[92mRunning Sanity Check\n\n"

# make sure we have a config file
if [ ! -f config/config.inc.php ]; then
  echo "config file missing";
  exit 1
fi

# make sure we're using the right imap server
if ! grep --quiet "default_host.*imap.xs4all.nl" config/config.inc.php; then
  echo "imapserver is not set to imap.xs4all.nl, stopping"
  exit 1
fi

# make sure we're using the right imap server
if ! grep --quiet "smtp_server.*smtp.xs4all.nl" config/config.inc.php; then
  echo "smtp server is not set to smtp.xs4all.nl, stopping"
  exit 1
fi

# make sure we're not using a debug mode
if grep --quiet "debug.*true" config/config.inc.php; then
  echo "roundcube is using a debug mode"
  exit 1
fi

# make sure we're not using impersonate in production
if grep --quiet "dovecot_impersonate" config/config.inc.php; then
  echo "roundcube is using dovecot_impersonate"
  exit 1
fi

# make sure we limit managesieve
if ! grep --quiet "XS4ALL" plugins/managesieve/managesieve.php; then
  echo "Not limiting managesieve"
  exit 1
fi
