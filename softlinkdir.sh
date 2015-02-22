#! /bin/sh

src=$1
dst=$2

ln -s $src $dst && ls -l $dst
