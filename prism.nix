{
  pkgs,
  prism,
  system,
}:
let
in {
  accountless-patchfile = pkgs.writeText "accounts.json" ''
    {"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "MSA"}],"formatVersion": 3}
  '';
  prism-fast-unwrapped = prism.prismlauncher-unwrapped.overrideAttrs (p: {
    # buildInputs = p.buildInputs ++ [ accountless-patchfile ];
    # postPatchPhase = ''
    #   cp ${accountless-patchfile} local/share/PrismLauncher/
    # '';
  });
  prism-fast = prism.prismlauncher;
}
