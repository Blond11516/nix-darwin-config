{ pkgs }:
with pkgs;
[
  bat
  btop
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
  openssh
  ffmpeg

  # MacOS App packages
  obsidian
  darwin.discrete-scroll
]
