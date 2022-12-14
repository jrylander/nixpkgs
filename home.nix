{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "jrylander";
    homeDirectory = "/home/jrylander";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";

    packages = with pkgs; [
      bind
      bitwarden-cli
      calibre
      chezmoi
      discord
      docker
      docker-compose
      entr
      fd
      fira-code
      fira-code-symbols
      gcc
      git
      gnome3.gnome-tweaks
      helix
      htop
      jetbrains.idea-ultimate
      signal-desktop
      just
      k9s
      killall
      kubectl
      logseq
      obsidian
      openconnect
      openssl
      openssl.dev
      pkg-config
      protobuf
      rustup
      slack
      spotify
      teams
      wireguard-tools
      wireshark
      xsel
    ];

    sessionVariables = {
      EDITOR = "hx";
      GOOGLE_APPLICATION_CREDENTIALS = "service-account-credentials.json";
      PKG_CONFIG_PATH = "/home/jrylander/.nix-profile/lib/pkgconfig";
    };
  };

  services = {
    dropbox = {
      enable = true;
    };
    syncthing = {
      enable = true;
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat.enable = true;

    alacritty = {
      enable = true;
      settings = {
        window = {
          dimensions = {
            columns = 132;
            lines = 42;
          };
        };
        font = {
          size = 14;
          normal = {
            family = "Fira Code";
            style = "Regular";
          };
        };
      };
    };

    go = {
      enable = true;
      goPath = "go";
    };

    tmux = {
      enable = true;
      shortcut = "w";
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      escapeTime = 0;
    };

    git = {
      enable = true;
      userEmail = "johan@rylander.cc";
      userName = "Johan Rylander";
      delta = {
        enable = true;
      };
      extraConfig = {
        core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        url."git@git.svt.se:".insteadOf = "https://git.svt.se/";
        init.defaultBranch = "master";
        safe.directory = "/etc/nixos";
        credential.helper = "store";
      };
    };

    chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      ];
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "docker" "docker-compose" "kubectl" ];
      };
      initExtra = ''
        export GPG_TTY=$(tty)

        # NVM
        export NVM_DIR=$HOME/.local/share/nvm
        if [[ ! -e $NVM_DIR ]]; then
          git clone https://github.com/nvm-sh/nvm.git $NVM_DIR
        fi
        source $NVM_DIR/nvm.sh
        source $NVM_DIR/bash_completion

        # Rustup
        export CARGO_HOME=$HOME/.cargo
        if [[ -e $CARGO_HOME ]]; then
          export PATH=$CARGO_HOME/bin:$PATH
        fi

        export PATH=~/.local/bin:$PATH

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi

        source ~/.zshrc-local || true
      '';
    };

    fzf = {
      enable = true;
    };
  };
}
