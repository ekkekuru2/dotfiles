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
    jq
    # fzf / zoxide は programs.fzf / programs.zoxide が入れるのでここには書かない。
    # zsh-completions は source するプラグインではなく補完関数の束なので、
    # home.packages 経由で profile に入れる。生成 .zshrc の mkOrder 520 が
    # $NIX_PROFILES/*/share/zsh/site-functions を fpath に足すため、
    # 570 の compinit に間に合う。
    zsh-completions
    gnupg
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
    rust-analyzer         # Rust LSP
    rustc
    cargo
    clippy                # checkOnSave 用
    ripgrep
    gcc                  # nvim-treesitter(main) がパーサをソースからビルドするのに必要な cc
    tree-sitter          # nvim-treesitter(main) は tree-sitter build で各パーサをビルドする
    nodejs               # markdown-preview.nvim のビルド(npm install)に必要
  ];

  # 以前は home/.config/zsh/.zshrc を home.file でそのまま配置し、プラグインは
  # zinit が実行時に git clone していた。シェルの起動がネットワークと
  # バージョン未固定の clone に依存するのをやめ、宣言的プラグインに移した。
  #
  # 生成される .zshrc の挿入順序 (home-manager の mkOrder)、把握しておくと
  # initContent をどこに置くか決めやすい:
  #   500 mkBefore             570 compinit          900 plugins を source
  #   510 fpath 整理           700 autosuggestions   910 fzf
  #   520 NIX_PROFILES → fpath 851 zoxide           1000 既定
  #   560 plugins → fpath                           1200 syntax-highlighting
  programs.zsh = {
    enable = true;

    # xdg.enable = false のため dotDir の既定は $HOME になってしまう。
    # 既存の ~/.config/zsh を使い続けるので明示する。
    # これを設定すると home-manager が ~/.zshenv に ZDOTDIR の export を
    # 書くので、NixOS 側の environment.sessionVariables.ZDOTDIR は不要になる。
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # history.path の既定は ${dotDir}/.zsh_history で既存の履歴ファイルと同じ。
    # size/save だけ従来の .zshrc と同じ値に上げる (既定は 10000)。
    history = {
      size = 1000000;
      save = 1000000;
    };

    shellAliases = {
      l = "ls -al --color=always";
      claude-dub = "CLAUDE_CONFIG_DIR=~/.config/claude-dubguild claude";
    };

    # zinit light で引いていたものの置き換え。syntax-highlighting と
    # autosuggestions は専用オプション側で面倒を見るのでここには書かない。
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      # instant prompt は端末出力を伴う処理より前に居ないと意味がないので最初期に置く。
      (lib.mkBefore ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      # 既定の 1000。テーマ本体の source (900) より後なので .p10k.zsh で上書きできる。
      ''
        # To customize prompt, run `p10k configure` or edit .p10k.zsh.
        [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

        # Ctrl + 矢印キーで単語ごとに移動
        bindkey ";5C" forward-word
        bindkey ";5D" backward-word
      ''
    ];
  };

  # zinit light Aloxaf/fzf-tab の相棒。従来は fzf 同梱の key-bindings.zsh /
  # completion.zsh を手でコピーした 650 行の fzf.zsh を source していたが、
  # `fzf --zsh` を source する方式に変えて本体との乖離をなくす。
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # .zshrc の eval "$(zoxide init zsh)" の置き換え。
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # programs.zsh を使うようになったので、この module の zsh 統合が実際に効く。
  # (以前は .zshrc が home-manager 管理外だったため eval "$(direnv hook zsh)" を
  #  .zshrc に手書きする必要があった)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # GPG agent。NixOS非依存にするため home-manager 側で管理する。
  # pinentry はヘッドレス環境でも動くよう curses をデフォルトにし、
  # デスクトップ環境では desktop.nix 側で pinentry-gnome3 に mkForce する。
  #
  # enableSshSupport は意図的に false。実際に使っているSSH鍵(~/.ssh/id_ed25519)は
  # GPGの認証用サブキーではない普通の鍵で、GNOMEの gcr-ssh-agent が管理している。
  # gpg-agentのSSH機能を有効にすると SSH_AUTH_SOCK を gcr-ssh-agent と奪い合い、
  # 鍵を1つも持たない gpg-agent 側が勝つと ssh 認証が壊れる。
  #
  # enableExtraSocket は true。ssh config の RemoteForward で
  # S.gpg-agent.extra をリモートに転送して署名するのに使っている。
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    enableExtraSocket = true;
    pinentry.package = pkgs.pinentry-curses;
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
    # .zshrc / .zshenv は programs.zsh が ${dotDir} 以下に生成するので、
    # ディレクトリ丸ごとの配置はやめる (キーが衝突する)。
    # .p10k.zsh は `p10k configure` が吐く 1500 行超の生成物で、Nix で
    # 表現する意味がないため素のファイルのまま置く。
    ".config/zsh/.p10k.zsh".source = ../../home/.config/zsh/.p10k.zsh;
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

