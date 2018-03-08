#!/bin/bash
# This file is meant to be executed via systemd.
source /usr/local/rvm/scripts/rvm
source /etc/profile.d/rvm.sh
export ruby_ver=$(rvm list default string)

export CONFIGURED=yes
export TIMEOUT=50
export APP_ROOT=/home/rails/rails_project
export RAILS_ENV="production"
export GEM_HOME="/home/rails/rails_project/vendor/bundle"
export GEM_PATH="/home/rails/rails_project/vendor/bundle:/usr/local/rvm/gems/${ruby_ver}:/usr/local/rvm/gems/${ruby_ver}@global"
export PATH="/home/rails/rails_project/vendor/bundle/bin:/usr/local/rvm/gems/${ruby_ver}/bin:${PATH}"

# Passwords
export SECRET_KEY_BASE=83d9d077961a6978abf0b264052db8d493ca96adec5d76acbeff18646a61eeee6619bb2d0fd84d9cc2290948bc94c53596f341e16015668845ea6a51c46821cb
export APP_DATABASE_PASSWORD=fa37dccf311faf4cbf4363b8dcd4a851

# Execute the unicorn process
/home/rails/rails_project/vendor/bundle/bin/unicorn \
        -c /etc/unicorn.conf -E production --debug
