#! /bin/bash

APPLICATION_ROOT=''
APPLICATION_DIR='repo'
APPLICATION_DOMAIN='library.hey.app'
APPLICATION_REMOTE_ROOT='/hey/application'
APPLICATION_REMOTE_PUBLIC_DIR=$APPLICATION_REMOTE_ROOT/library/public
HOMESTEAD_DIR='homestead'
HOMESTEAD_VERSION='v6.2.2'
SSH_KEY_PAIR_NAME=''

brew cask install virtualbox
brew cask install vagrant
vagrant box add laravel/homestead
mkdir -p $APPLICATION_ROOT
cd $APPLICATION_ROOT
git clone git@github.com:grevych/hey-library.git $APPLICATION_DIR
git clone git@github.com:laravel/homestead.git $HOMESTEAD_DIR
cd $HOMESTEAD_DIR
git checkout $HOMESTEAD_VERSION
bash init.sh
cat <<EOF > Homestead.yaml
ip: "192.168.10.10"
memory: 2048
cpus: 1
provider: virtualbox

authorize: ~/.ssh/$SSH_KEY_PAIR_NAME.pub

keys:
- ~/.ssh/$SSH_KEY_PAIR_NAME

folders:
- map: ../$APPLICATION_DIR
  to: $APPLICATION_REMOTE_ROOT

sites:
- map: $APPLICATION_DOMAIN
  to: $APPLICATION_REMOTE_PUBLIC_DIR

databases:
- homestead

# blackfire:
#     - id: foo
#       token: bar
#       client-id: foo
#       client-token: bar

# ports:
#     - send: 50000
#       to: 5000
#     - send: 7777
#       to: 777
#       protocol: udp
EOF
sudo cat <<EOF >> /etc/hosts
192.168.10.10 $APPLICATION_DOMAIN
EOF
vagrant up
#vagrant ssh


# Available locations
# localhost:8000
# library.hey.app
# 192.168.10.10

