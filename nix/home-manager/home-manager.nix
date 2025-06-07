{ config, pkgs, lib, sources, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ekkekuru2";
  home.homeDirectory = "/home/ekkekuru2";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    zotero
    wolfram-engine
    wolfram-notebook
    kicad
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "wolfram-engine" "vscode"
    ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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


  programs.git = {
    enable = true;
    userName = "ekkekuru2";
    userEmail = "ekke@ekke.jp";
    extraConfig = {
      init = {defaultBranch = "main";};
      commit = {gpgsign = "true";};
      user = {signingKey = "BED215D4423E036A";};
    };
  };



  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
    	lazy-nvim
    ];
    extraLuaConfig = ''
    	require("lazy").setup()
    '';
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ekkekuru2/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

