{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.nakama;

  configFile = pkgs.writeTextFile {
    name = "config.yaml";
    text = builtins.toJSON cfg.settings;
  };
in {
  imports = [ ./options.nix ];

  # options specific to nix
  options.services.nakama = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables the Nakama server
      '';
    };

		user = mkOption {
			default = defaultUser;
			example = "john";
			type = types.str;
			description = lib.mdDoc ''
				The name of an existing user account to use to own the Nakama server
				process. If not specified, a default user will be created.
			'';
		};

		group = mkOption {
			default = defaultUser;
			example = "users";
			type = types.str;
			description = lib.mdDoc ''
				Group to own the Nakama process.
			'';
		};

    cluster = {
      openFirewall = mkOption {
				default = false;
				type = bool;
				description = lib.mdDoc ''
					Open ports in the firewall for nakama cluster.
				'';
			};
    };
    console = {
      openFirewall = mkOption {
				default = false;
				type = bool;
				description = lib.mdDoc ''
					Open port in the firewall for the console.
				'';
			};
    };
    metrics = {
      openFirewall = mkOption {
				default = false;
				type = bool;
				description = lib.mdDoc ''
					Open port in the firewall for prometheus.
				'';
			};
    };
    socket = {
      openFirewall = mkOption {
				default = false;
				type = bool;
				description = lib.mdDoc ''
					Open port in the firewall for the client socket connection.
				'';
			};
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.socket.openFirewall cfg.socket.port;

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
        LimitNPPROC = "1048576:1048576";
        ExecStart = "${pkgs.nakama}/bin/nakama --config ${configFile}";
      };
    };
  };
}
