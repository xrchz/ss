#!/bin/bash

set -e

pushd $HOME

# Poly/ML

svn checkout --quiet svn://svn.code.sf.net/p/polyml/code/trunk polyml
pushd polyml/polyml
./configure --prefix=$HOME/polyml --enable-shared
make
make compiler
make install
popd

export PATH=$PATH:$HOME/polyml/bin
export LD_LIBRARY_PATH=$HOME/polyml/lib

# HOL

git clone --quiet https://github.com/mn200/HOL.git
pushd HOL
poly < tools/smart-configure.sml
bin/build -small -nograph
popd

# Create the archive

tar --create --auto-compress --file=cache.tar.xz polyml HOL

# Set up ssh

mkdir -p -m700 .ssh
popd
mv a $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa
mv b $HOME/.ssh/known_hosts
chmod 644 $HOME/.ssh/known_hosts
pushd $HOME

# Upload

rsync -Pz cache.tar.xz xrchz@xrchz.strongspace.com:/strongspace/xrchz/cache

popd
