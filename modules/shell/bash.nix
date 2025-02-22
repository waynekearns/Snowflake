{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.bash;
in {
  options.modules.shell.bash = { enable = mkBoolOpt true; };

  config = mkIf cfg.enable (mkMerge [
    {
      homeManager = {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          config.whitelist.prefix = [ "/home" ];
        };

        programs.bash = {
          enable = true;
          historySize = 5000;
          historyFileSize = 5000;
          historyIgnore = [ "nvim" "neofetch" ];

          shellAliases = {
            ls = "exa -Slhg --icons";
            lsa = "exa -Slhga --icons";
            temacs = "emacsclient -t";

            wup = "systemctl start wg-quick-Akkadian-VPN.service";
            wud = "systemctl stop wg-quick-Akkadian-VPN.service";
          };
        };
      };
    }

    # Starship intended for fish rice -> side-effect (hehe)
    (mkIf config.modules.shell.fish.enable {
      homeManager.programs.bash.bashrcExtra = ''
        eval "$(starship init bash)"
      '';
    })
  ]);
}
