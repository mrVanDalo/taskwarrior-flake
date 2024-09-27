{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with types;
let
  mkMagicMergeOption =
    {
      description ? "",
      example ? { },
      default ? { },
      apply ? id,
      ...
    }:
    mkOption {
      inherit
        example
        description
        default
        apply
        ;
      type =
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "bool, int, float or str";
              emptyValue.value = { };
            };
        in
        valueType;
    };
in
{

  options.bugwarrior.enable = mkEnableOption "bugwarrior";
  options.bugwarrior.config = mkMagicMergeOption {
    type = attrs;
    default = { };
  };

  config = mkIf config.bugwarrior.enable {
    home.file.".config/bugwarrior/bugwarrior.toml".source =
      (pkgs.formats.toml { }).generate "bugwarriorrc.toml"
        (config.bugwarrior.config);
    home.packages = [
      # todo install package from this flake
      pkgs.bugwarrior
    ];
  };

}
