{ config, pkgs, lib, sources, ... }:

{
  imports = [ ./base.nix ];

  # username / homeDirectory は base.nix の $USER/$HOME 動的解決に任せる
  # (デスクトップも常に ekkekuru2 で --impure 実行するので同じ結果になる)

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # base.nix の home.packages と自動でマージされるので、ここには
  # デスクトップ環境固有のパッケージだけを書く。
  home.packages = with pkgs; [
    zotero
    wolfram-engine
    wolfram-notebook
    kicad
    obsidian
    zoom-us
    inkscape-with-extensions
    obs-studio
    ardour
    mixxx
    spotify
    qpwgraph
    raysession
    audacity
    lsp-plugins
    sfizz
    reaper
    davinci-resolve
    thunderbird
    jtdx
    zed-editor
    hydrogen
    ltspice
    gimp
    musescore
    darktable
    kdePackages.kdenlive
    friture
    virt-viewer
    # NixOS の environment.systemPackages から移設(ただのユーザーアプリのため)
    kitty
    slack
    discord
    chromium
    python3
    vlc
    freerdp
    openconnect
    wireguard-tools
    firefox
  ];

  # pinentry はGUIが使えるデスクトップなので gnome3 に上書き(base.nix は pinentry-curses)
  services.gpg-agent.pinentry.package = lib.mkForce pkgs.pinentry-gnome3;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "wolfram-engine" "vscode" "obsidian" "zoom" "spotify" "davinci-resolve" "ltspice" "reaper" "WolframEngine_14.1.0_LIN.sh"
      "slack" "discord" "discord-unwrapped"
    ];

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
    #  ms-vscode.cpptools
    ];
    #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #  {
    #    name = "wolfram-language-notebook";
    #    publisher = "njpipeorgan";
    #    version = "0.1.1";
    #    sha256 = "sha256-VBv9SytaPdAsIMMhvQqSOpZqVpIJ+E9va2mrofV5JTs=";
     # }
    # ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        pkgs.fcitx5-skk
        pkgs.fcitx5-gtk
      ];
    };
  };
  # note: https://github.com/nix-community/home-manager/issues/1011
  home.sessionVariables.XMODIFIERS = "@im=fcitx";
  home.sessionVariables.QT_IM_MODULE = "fcitx";
  home.sessionVariables.GTK_IM_MODULE = "fcitx";
  # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#GNOME
  # Installed Kimpanel Gnome extension with GUI not through Nix
  # Should use nix to manage Gnome Extension https://nixos.wiki/wiki/GNOME

  # programs.fcitx5-skk = {
  #  dictionaries = (
  #    with pkgs.skkDictionaries; [ l geo station jis2 jis3_4 assoc ] ++
  #    [
  #      (pkgs.fetchurl {
  #        url = "https://github.com/ibuki2003/skk_dics/releases/download/untagged-b135c1c0e0d8fb30f981/wikipedia_with_descripts_sorted.utf8.txt";
  #        hash = "sha256-6a6Wh256nozUC62jMQWrPONet3TOKTpYgMAg93BahH0=";
  #      })
  #      "${sources.skkemoji.src}/SKK-JISYO.emoji.utf8"
  #    ]
  #  );
  #};

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.kimpanel; }
      { package = pkgs.gnomeExtensions.gsconnect; }
    ];
  };

  # base.nix の home.file とキーが被らない分だけ追加。
  # ".config/zsh" / ".config/nvim" は base.nix 側にすでに定義されている。
  home.file = {
    ".WolframEngine" = {
      source = ../../home/.WolframEngine;
      recursive = true;
    };
  };
}
