{ pkgs, ... }: {
  environment = {
    shells = with pkgs; [ bash zsh ];
    systemPackages = [ 
      pkgs.coreutils
      pkgs.poetry
      pkgs.nodePackages_latest.aws-cdk
      pkgs.uv
    ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };
}
