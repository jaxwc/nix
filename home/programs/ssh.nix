{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = true;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
      IdentityAgent = "\"${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
    };
    settings."github.com" = {
      HostName = "github.com";
      User = "git";
    };
    settings."intersect" = {
      HostName = "intersect";
      User = "jackson";
      Port = 22;
      IdentityFile = "~/.ssh/intersect.pub";
      IdentitiesOnly = true;
      ForwardAgent = false;
    };
  };

  home.file.".ssh/intersect.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/YY33gy1VKT1WV192IycMRCuQZLnumqFqtVt0TpyIl Intersect SSH Key
  '';
}
