{
  enable = true;
  onActivation = {
    cleanup = "zap";
    autoUpdate = true;
  };
  taps = [
    "homebrew/bundle"
    "joallard/cf-keylayout"
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
    "remotemobprogramming/brew/mob"
  ];
  casks = [
    "discord"
    "cf-keylayout"
    "alt-tab"
    "figma"
    "firefox"
    "google-chrome"
    "libreoffice"
    "microsoft-teams"
    "obs"
    "scroll-reverser"
    "keymapp"
    "zed"
    "dbeaver-community"
    "slack"
    "visual-studio-code"
    "intellij-idea"
    "yaak"
    "thunderbird"
    "pycharm"
    "docker-desktop"
    "ghostty"
    "sol"
  ];
  # How to find a mas app ID: https://github.com/mas-cli/mas?tab=readme-ov-file#-usage
  masApps = {
    # Xcode = 497799835;
  };
}
