{ config, lib, pkgs, ... }:
let
  cfg = config.services.nakama;
  defaultUser = "nakama";
  configFormat = pkgs.formats.yaml {};
  configFile = configFormat.generate "config.yaml" cfg.settings;
in {
  imports = [ ./options.nix ];
  # options specific to nix
  options.services.nakama = with lib; {
    enable = mkEnableOption (lib.mdDoc "nakama");

    user = mkOption {
      default = defaultUser;
      example = "john";
      type = types.str;
      description = mdDoc ''
        The name of an existing user account to use to own the Nakama server
        process. If not specified, a default user will be created.
      '';
    };

    group = mkOption {
      default = defaultUser;
      example = "users";
      type = types.str;
      description = mdDoc ''
        Group to own the Nakama process.
      '';
    };

    cockroachdb = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Tells Nakama to use CockroachDB as its database. If this option is
          disabled then you will need to set up PostgreSQL yourself as it is
          unofficially supported by nakama.
        '';
      };
      certsDir = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = mdDoc ''
          The path to the certificate directory. If not set then CockroachDB
          will be run in insecure mode. For more details:
          https://www.cockroachlabs.com/docs/stable/cockroach-start#security
        '';
      };
    };

    cluster = {
      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Open ports in the firewall for nakama cluster.
        '';
      };
    };
    console = {
      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Open port in the firewall for the console.
        '';
      };
    };
    metrics = {
      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Open port in the firewall for prometheus.
        '';
      };
    };
    socket = {
      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Open port in the firewall for the client socket connection.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups."${cfg.group}" = { };
    users.users."${cfg.user}" = {
      group = config.users.groups."${cfg.group}".name;
      isSystemUser = true;
    };

    environment.systemPackages = if cfg.cockroachdb.enable then [ pkgs.cockroachdb ] else [ ];
    services.cockroachdb = lib.mkIf cfg.cockroachdb.enable {
      enable = true;
      insecure = cfg.cockroachdb.certsDir == null;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.socket.openFirewall cfg.settings.socket.port;

    systemd.services.nakama = {
      description = "Nakama server";
      wantedBy = ["multi-user.target"];
      requires = ["cockroach.service"];
      wants = ["network.target"];
      after = ["network.target"];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = 3;
        TimeoutSec = 6;
        LimitNOFILE = "1048576:1048576";
        LimitNPROC = "1048576:1048576";
        ExecStartPre = "${pkgs.nakama}/bin/nakama migrate up --config ${configFile}";
        ExecStart = "${pkgs.nakama}/bin/nakama --config ${configFile}";
      };
    };
  };
}
