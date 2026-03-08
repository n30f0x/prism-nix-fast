{
  pkgs,
  prism,
  system,
}:
let
  plauncher = "PrismLauncher";
in rec {
  accountless-patchfile = pkgs.writeText "accounts.json" ''
    {"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "MSA"}],"formatVersion": 3}
  '';
  compat-fix = pkgs.qt6Packages.qt5compat.override { qtbase = pkgs.qt6.qtbase; };
  prism-fast-unwrapped = prism.prismlauncher-unwrapped.overrideAttrs (pre: {
    # version = "9.4";
    # src = pkgs.fetchFromGitHub {
    #   owner = plauncher;
    #   repo = plauncher;
    #   tag = "9.4";
    #   hash = "sha256-q8ln54nepwbJhC212vGODaafsbOCtdXar7F2NacKWO4=";
    # };
    # buildInputs = pre.buildInputs ++ [ compat-fix pkgs.kdePackages.quazip pkgs.ghc_filesystem ];
    patches = [
      ./offline.patch
    ];
  });

  prism-fast = prism.prismlauncher.override {
    prismlauncher-unwrapped = prism-fast-unwrapped;
  };
}
