#!/bin/sh
set -e
# Install NodeJS on raspbian
#

_ARCH=`arch`

echo "================    Downloading NodeJS    ================"
echo "  - Your Arch is: $_ARCH"

#apt-get update
#apt-get install git-core libnss-mdns libavahi-compat-libdnssd-dev -y
#wget http://node-arm.herokuapp.com/node_latest_armhf.deb
#dpkg -i node_latest_armhf.deb

_URL="https://nodejs.org/dist"
_DIST="latest"
_MAJOR_VERSION=100

# Remove previous junk if any
rm SHASUMS256.txt* | echo "Nothing to remove from previous run"
rm -rf node-v* | echo "No previous node packages downloaded"

download_install()
{
  echo "    =====> Downloading"
  wget $1$2
  echo "================    Unpacking NodeJS    ================"
  tar -xzf $2
  _UNPACKED=`echo $2 | sed 's/.tar.*//'`
  [ -z "$_UNPACKED" ] && echo "ERROR finding dir!" && exit 1
  echo "    ====> Entering dir: $_UNPACKED"
  cd $_UNPACKED
  echo "================    Installing NodeJS    ================"
  sudo cp -R * /usr/local/
  echo "================    Testing NodeJS    ================"
  node -v
  npm -v
  cd -
  echo "================    DONE!    ================"

  exit
}

check_if_exists()
{
  wget $_URL/$1/SHASUMS256.txt
  _LAST_VERSION=`cat SHASUMS256.txt | grep "node" -m 1| sed 's/^.*\(-v.*0-\).*$/\1/'`
  _LOOKING_FOR="node${_LAST_VERSION}linux-$_ARCH.tar.gz"
  echo "  - Last version is: $_LAST_VERSION, looking now for package compatible: $_LOOKING_FOR"
  _MAJOR_VERSION=`echo $_LAST_VERSION | sed 's/-v//' | cut -f1 -d"."`
  echo "  - Major version is $_MAJOR_VERSION"
  _MATCH=`cat SHASUMS256.txt | grep $_LOOKING_FOR -m 1 || echo ''`
  echo "looking now for that version in the server..."
  [ ! -z "$_MATCH" ] && download_install  $_URL/$1/ $_LOOKING_FOR || echo "Major version $_MAJOR_VERSION does not exist, checking lower version..." 
}

check_if_exists $_DIST
_DELTA=1

while [ $_MAJOR_VERSION -ge 8 ]
do
  _MAJOR_VERSION=`expr $_MAJOR_VERSION - $_DELTA`
  rm SHASUMS256.txt
  check_if_exists "latest-v$_MAJOR_VERSION.x"
done

#TODO: Test now if is not empty

#node -v
#npm -v
#npm install -g node-gyp
