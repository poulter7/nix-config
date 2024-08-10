{ pkgs, ... }: {
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPackages = [ 
      pkgs.coreutils
      pkgs.poetry
      pkgs.nodePackages_latest.aws-cdk
    ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };
}