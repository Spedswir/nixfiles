#!/usr/bin/env bash

gitDir="${HOME}/Documents/git-repos"
if [ ! -d "$gitDir" ]; then
  mkdir -p "$gitDir"
fi

cd "$gitDir"
# My Repos
if [ ! -d "obsidian-archives" ]; then
  git clone https://gitea.spedswir.com/spedswir/obsidian-archives.git
fi

if [ ! -d "OtherFiles" ]; then
  git clone https://gitea.spedswir.com/spedswir/OtherFiles.git
fi

# Other Repos
if [ ! -d "Manga-Downloader-Plus" ]; then
  git clone https://github.com/sparky8512/Manga-Downloader-Plus.git
fi
