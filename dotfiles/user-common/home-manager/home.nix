{config, pkgs ? import <stable>, ...}:
{
  home = {
    username = "tiffany";
    homeDriectory = "/home/tiffany";
    stateVersion = "24.11";

    packages = with pkgs; {
      bash-language-server
      lua-language-server
      htmx-lsp
      nil
      pyright
      typescript-language-server
    };
  };

  programs.home-manager.enable = true;
}

