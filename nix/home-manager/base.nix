{ config, pkgs, lib, sources, ... }:

let
  # headless は「接続先で割り当てられたユーザー」で使う想定なので、
  # username / homeDirectory を実行時の環境変数から取る。
  # スパコンや VM ではユーザー名を選べず、home も /home 以外
  # (/work/<user> 等) に置かれることがあるため、$HOME をそのまま尊重する。
  #
  # これは Nix の純粋評価から外れる「外部入力」なので、flake の pure eval
  # では getEnv が "" を返す。必ず --impure を付けて実行すること:
  #   home-manager switch --flake .#headless --impure
  # 付け忘れると "" のまま壊れた設定になるので throw で弾く。
  envUser = builtins.getEnv "USER";
  envHome = builtins.getEnv "HOME";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username =
    if envUser != "" then envUser
    else throw "base.nix: $USER が空です。home-manager を --impure で実行してください";
  home.homeDirectory =
    if envHome != "" then envHome
    else "/home/${envUser}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

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
    unzip
    p7zip
    fzf
    zoxide
    jq
    # Network Tools
    whois
    traceroute
    dig
    pyright
    # Neovim LSP
    clang-tools          # clangd 含む
    typescript-language-server
    typescript
    nil                  # Nix LSP
    lua-language-server
    prisma-language-server  # Prisma LSP (prismals)
    ripgrep
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      
    ];


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings= {
      user = {
        name = "ekkekuru2";
        email = "ekke@ekke.jp";
      };
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
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/zsh" = {
      source = ../../home/.config/zsh;
      recursive = true;
    };
    ".config/nvim" = {
      source = ../../home/.config/nvim;
      recursive = true;
    };

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

