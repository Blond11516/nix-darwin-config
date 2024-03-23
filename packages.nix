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
  zoxide
  fzf

  # MacOS App packages
  slack
  rectangle
  obsidian
  darwin.discrete-scroll
  vscode
  jetbrains.idea-ultimate
]