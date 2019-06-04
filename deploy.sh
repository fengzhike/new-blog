#!/bin/bash
user='git'
branch='master'
projectDir='.blog'
srcDir='public'

hexo g

[[ ! -d "$projectDir" ]] && git clone https://github.com/fengzhike/fengzhike.github.io.git $projectDir
[ ! -n "$1"] && echo 'need commit components' && exit 1
echo '-rf .blog/*'
rm -rf ${projectDir}/*

echo 'cp  public/* .blog/'
cp -r public/* $projectDir/

echo 'cd ${projectDir}'

cd $projectDir

git add .
git commit -m $1
git push
