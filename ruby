#!/bin/bash -l
source lib/helpers.sh

RUBY_VER="2.0.0-p247"

got_command 'rvm'
if [ $? -eq 0 ]; then
  boom "RVM found.. I'm expecting rbenv -- rvm implode and setup rbenv"
else
  echo "rvm not found.. moving on with rbenv"
fi

got_command 'ruby'
if [ $? -eq 0 ]; then
  yak "got ruby already - checking against $RUBY_VER target"
  r_version=`ruby --version | awk '{ print $2}'`
  existing_version=${r_version/p/-p}
  if [ $existing_version == "$RUBY_VER" ]; then 
    yak "you have the version of ruby in your path I would install ... skipping install"
  else
    echo "your existing ruby $existing_version not my target version $RUBY_VER"

    got_command 'rbenv'
    if [ $? -eq 0 ]; then
      yak "installing ruby-$RUBY_VER"
      rbenv install $RUBY_VER
      rbenv rehash
      rbenv global $RUBY_VER
    else
      boom "rbenv not found .. failed to install ruby $RUBY_VER"
    fi
  fi
fi

got_command 'bundle'
if [ $? -eq 1 ]; then
  yak "installing bundler"
  gem install bundler
fi

echo "
#> you should be good to go now... try the following:
exec $SHELL -l
bundle "
