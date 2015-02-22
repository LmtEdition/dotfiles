#! /bin/sh

src=$1
dst=$2

ln -sv $src $dst && ls -l $dst
