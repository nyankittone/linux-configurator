{config, lib, pkgs, ...}:
{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system-manager.allowAnyDistro = true;

    # In all honesty, it's probably beter if I just installed nvim through apt, but maybe Debian should
    # consider shipping a backported neovim instead of expecting people to use an obsolete version of
    # the editor.
    environment = {
      systemPackages = [
          pkgs.neovim
          pkgs.vifm-full
          pkgs.home-manager
      ];
    };
  };
}

