{ config, pkgs, ... }:
let
  flakeryDomain = builtins.readFile /metadata/flakery-domain;
in
{
  system.stateVersion = "23.05";
  services.tailscale = {
    enable = true;
    authKeyFile = "/tsauthkey";
    extraUpFlags = [ "--ssh" "--hostname" "hercules" ];
  };



  services.hercules-ci-agent.enable = true;
  services.hercules-ci-agent.concurrentTasks = 4; # Number of jobs to run

    # chown /home/alice/.ssh to alice
  # set permissions for /home/alice/.ssh/id_ed25519 to 600
  systemd.services.fix-ssh-permissions = {
    description = "Fix SSH permissions";
    after = [ "network-pre.target" ];
    wants = [ "network-pre.target"];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";

    script = ''
      chown -R hercules-ci-agent /var/lib/hercules-ci-agent
      chmod o-rwx /var/lib/hercules-ci-agent/secrets
    '';
  };


}
