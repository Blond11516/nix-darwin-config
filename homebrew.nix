{
  enable = true;
  onActivation = {
    cleanup = "zap";
    autoUpdate = true;
  };
  taps = [
    "homebrew/bundle"
    "joallard/cf-keylayout"
    "null-dev/firefox-profile-switcher"
  ];
  brews = [
    "autoconf"
    "openssl"
    "gettext"
    "cairo"
    "cloc"
    "firefoxpwa"
    "harfbuzz"
    "openjdk"
    "fop"
    "gnupg"
    "libxslt"
    "mise"
    "openssl@1.1"
    "python@3.11"
    "wxwidgets"
    "zsh-autosuggestions"
    "firefox-profile-switcher-connector"
    "remotemobprogramming/brew/mob"
    "podman"
    "podman-compose"
  ];
  casks = [
    "discord"
    "cf-keylayout"
    "mongodb-compass"
    "alt-tab"
    "figma"
    "firefox"
    "foxitreader"
    "google-chrome"
    "libreoffice"
    "microsoft-teams"
    "obs"
    "scroll-reverser"
    "keymapp"
    "zed"
    "dbeaver-community"
    "alacritty"
    "slack"
    "visual-studio-code"
    "intellij-idea"
    "yaak"
    "raycast"
    "thunderbird"
    "pycharm"
    "docker"
    "ghostty"
  ];
  # How to find a mas app ID: https://github.com/mas-cli/mas?tab=readme-ov-file#-usage
  masApps = {
    # Xcode = 497799835;
  };
}
