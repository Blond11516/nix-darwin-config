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
  ngrok

  # MacOS App packages
  obsidian
  darwin.discrete-scroll
  vscode
  jetbrains.idea-ultimate
]