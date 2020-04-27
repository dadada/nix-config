{ config, pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    plugins = with pkgs; [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "c3defd4a922e97120503b45e26efa775bc672b50";
          sha256 = "1k5b0nva0mbqc9830qhbcwxsi8d9b2p4ws1fq0bw9nkf2ripyp4p";
        };
      }
    ];
    interactiveShellInit = ''
      # fish git prompt
      set __fish_git_prompt_show_informative_status 'yes'
      set __fish_git_prompt_showdirtystate 'yes'
      set __fish_git_prompt_showstashstate 'yes'
      set __fish_git_prompt_showuntrackedfiles 'yes'
      set __fish_git_prompt_showupstream 'yes'
      set __fish_git_prompt_showcolorhints 'yes'

      set fish_greeting

      # disable path shortening
      set fish_prompt_pwd_dir_length 0

      set -U FZF_LEGACY_KEYBINDINGS 0
      #set -x TERM xterm-256color

      #if status is-interactive
      #and not status is-login
      #and not set -q TMUX
      #and string match -qr "^xterm-.*" "$TERM"
      #  exec tmux
      #end
    '';
    promptInit = ''
      function fish_prompt
	set last_status $status
	printf '%s %s:%s ' \
	(set_color red
		echo $last_status) \
	(set_color green
		hostname) \
	(set_color blue
		prompt_pwd)
	set_color normal
      end

      function fish_right_prompt
	printf '%s' (__fish_git_prompt)
      end
      '';
    shellAliases = {
      gst = "git status";
      gco = "git commit";
      glo = "git log";
      gad = "git add";
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      mv = "mv -i";
      cp = "cp -i";
    };
  };

  home.packages = [ pkgs.exa ];

}
