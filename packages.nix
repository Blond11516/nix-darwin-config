{ pkgs }:
with pkgs;
[ 
  bat
  btop
  direnv
  curl
  flyctl
  hyperfine
  jq
  mob
  nil
  git
  just
  eza

  # MacOS App packages
  slack
  rectangle
  obsidian
  iterm2
  darwin.discrete-scroll
  vscode
  jetbrains.idea-ultimate
]