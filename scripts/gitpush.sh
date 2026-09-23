#!/usr/bin/env bash
cd $1
git pull
git add .
git commit -a -m "Script update dotfiles on $(date +"%Y-%m-%d %T")"

git push

echo "Git Update Complete!"

exit
