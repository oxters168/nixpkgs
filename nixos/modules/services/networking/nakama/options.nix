{ lib, config, ... }:
let
  cfg = config.services.nakama;
in {
  # the nakama server customization options
  options.services.nakama = with lib; {
    settings = {
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Nakama node name (must be unique) - It will default to nakama. This name is also used in the log
          files.
        '';
      };
      data_dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          An absolute path to a writeable folder where Nakama will store its data, including logs. Default
          value is the working directory that Nakama was started on.
        '';
      };
      shutdown_grace_sec = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Maximum number of seconds to wait for the server to complete work before shutting down. If 0 the
          server will shut down immediately when it receives a termination signal. Default value is 0.
        '';
      };

      cluster = {
        gossip_bindaddr = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Interface address to bind Nakama to for discovery. By default listening on all interfaces.
          '';
        };
        gossip_bindport = mkOption {
          type = types.nullOr types.number;
          default = null;
          description = lib.mdDoc ''
            Port number to bind Nakama to for discovery. Default value is 7352.
          '';
        };
        join = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            List of hostname and port of other Nakama nodes to connect to.
          '';
        };
        max_message_size_bytes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum amount of data in bytes allowed to be sent between Nakama nodes per message. Default
            value is 4194304.
          '';
        };
        rpc_port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Port number to use to send data between Nakama nodes. Default value is 7353.
          '';
        };
        local_priority = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            When set to true, prefer local resources where possible.
          '';
        };
        work_factor_interval_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The update frequency for work factor sync operations.
          '';
        };
      };

      console = {
        address = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The IP address of the interface to listen for console traffic on. Default listen on all available
            addresses/interfaces.
          '';
        };
        max_message_size_bytes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum amount of data in bytes allowed to be read from the client socket per message.
          '';
        };
        idle_timeout_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum amount of time in milliseconds to wait for the next request when keep-alive is enabled.
          '';
        };
        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Password for the embedded console. Default is “password”.
          '';
        };
        port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The port for accepting connections for the embedded console, listening on all interfaces. Default
            value is 7351.
          '';
        };
        read_timeout_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum duration in milliseconds for reading the entire request.
          '';
        };
        signing_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Key used to sign console session tokens.
          '';
        };
        token_expiry_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Token expiry in seconds. Default 86400.
          '';
        };
        username = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Username for the embedded console. Default is “admin”.
          '';
        };
        write_timeout_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum duration in milliseconds before timing out writes of the response.
          '';
        };
      };

      database = {
        address = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            List of database nodes to connect to. It should follow the form of username:password@address:port/dbname
            (postgres:// protocol is appended to the path automatically). Defaults to root@localhost:26257.
          '';
        };
        conn_max_lifetime_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Time in milliseconds to reuse a database connection before the connection is killed and a new one is
            created.. Default value is 0 (indefinite).
          '';
        };
        max_idle_conns = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum number of allowed open but unused connections to the database. Default value is 100.
          '';
        };
        max_open_conns = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum number of allowed open connections to the database. Default value is 0 (no limit).
          '';
        };
        dns_scan_interval_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Number of seconds between scans looking for DNS resolution changes for the database hostname. Default
            60.
          '';
        };
      };

      iap = {
        apple = {
          shared_password = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Your application's shared password.
            '';
          };
          notifications_endpoint_id = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              The id of the endpoint to receive Apple Subscription Notifications. E.g.: Setting this to foo will
              activate the endpoint at path: /v2/console/apple/subscriptions/foo.
            '';
          };
        };
        google = {
          client_email = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              The Service Account Client Email value.
            '';
          };
          private_key = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              The Service Account Private Key value.
            '';
          };
          notifications_endpoint_id = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              The id of the endpoint to receive Google Real-time developer notifications. E.g.: Setting this to foo
              will activate the endpoint at path: /v2/console/google/subscriptions/foo.
            '';
          };
          package_name = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              The package name of the app. Required if notifications_endpoint_id is set.
            '';
          };
          refund_check_period_min = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = lib.mdDoc ''
              The periodicity of the background Google refund API checks. Required if a refund hook is set. Defaults
              to 15 minutes.
            '';
          };
        };
        huawei = {
          public_key = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Huawei IAP store Base64 encoded Public Key.
            '';
          };
          client_id = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Huawei OAuth client secret.
            '';
          };
          client_secret = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Huawei OAuth app client secret.
            '';
          };
        };
      };

      leaderboard = {
        blacklist_rank_cache = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Disable rank cache for leaderboards with matching leaderboard names. To disable rank cache entirely, use *,
            otherwise leave blank to enable rank cache.
          '';
        };
        callback_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of the leaderboard and tournament callback queue that sequences expiry/reset/end invocations. Default
            65536.
          '';
        };
        callback_queue_workers = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Number of workers to use for concurrent processing of leaderboard and tournament callbacks. Default 8.
          '';
        };
      };

      logger = {
        compress = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            This determines if the rotated log files should be compressed using gzip.
          '';
        };
        file = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Log output to a file (as well as stdout if set). Make sure that the directory and the file is writable.
          '';
        };
        format = mkOption {
          type = types.enum [ null "JSON" "Stackdriver" ];
          default = null;
          description = lib.mdDoc ''
            Set logging output format. Can either be 'JSON' or 'Stackdriver'. Default is 'JSON'.
          '';
        };
        level = mkOption {
          type = types.enum [ null "debug" "info" "warn" "error" ];
          default = null;
          description = lib.mdDoc ''
            Minimum log level to produce. Values are debug, info, warn and error. Default is info.
          '';
        };
        local_time = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            This determines if the time used for formatting the timestamps in backup files is the computer's local time.
            The default is to use UTC time.
          '';
        };
        max_age = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The maximum number of days to retain old log files based on the timestamp encoded in their filename. The
            default is not to remove old log files based on age.
          '';
        };
        max_backups = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The maximum number of old log files to retain. The default is to retain all old log files (though max_age may
            still cause them to get deleted.)
          '';
        };
        max_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The maximum size in megabytes of the log file before it gets rotated. It defaults to 100 megabytes. Default is
            100.
          '';
        };
        rotation = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Rotate log files. Default is false.
          '';
        };
        stdout = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Redirect logs to console standard output. The log file will no longer be used. Default is true.
          '';
        };
      };

      match = {
        call_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of the authoritative match buffer that sequences calls to match handler callbacks to ensure no overlaps.
            Default 128.
          '';
        };
        deferred_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of the authoritative match buffer that holds deferred message broadcasts until the end of each loop execution.
            Default 128.
          '';
        };
        input_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of the authoritative match buffer that stores client messages until they can be processed by the next tick.
            Default 128.
          '';
        };
        join_attempt_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of the authoritative match buffer that limits the number of in-progress join attempts. Default 128.
          '';
        };
        join_marker_deadline_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Deadline in milliseconds that client authoritative match joins will wait for match handlers to acknowledge joins.
            Default 5000.
          '';
        };
        label_update_interval_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Time in milliseconds between when match labels are updated. Default 1000.
          '';
        };
        max_empty_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum number of consecutive seconds that authoritative matches are allowed to be empty before they are stopped. 0
            indicates no maximum. Default 0.
          '';
        };
      };

      metrics = {
        namespace = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Namespace for Prometheus or prefix for Stackdriver metrics. It will always prepend node name. Default value is empty.
          '';
        };
        prefix = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Prefix for metric names. Default is 'nakama', empty string disables the prefix.
          '';
        };
        prometheus_port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Port to expose Prometheus. Default value is 0 which disables Prometheus exports.
          '';
        };
        reporting_freq_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Frequency of metrics exports. Default is 60 seconds.
          '';
        };
      };

      runtime = {
        call_stack_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            (Deprecated) Size of each runtime instance's call stack. Default 128.
          '';
        };
        env = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            List of Key-Value properties that are exposed to the Runtime scripts as environment variables.
          '';
        };
        event_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of the event queue buffer. Default 65536.
          '';
        };
        event_queue_workers = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Number of workers to use for concurrent processing of events. Default 8.
          '';
        };
        http_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            A key used to authenticate HTTP Runtime invocations. Default value is defaultkey.
          '';
        };
        js_entrypoint = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Specifies the location of the bundled JavaScript runtime source code.
          '';
        };
        js_max_count = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum number of JavaScript runtime instances to allocate. Default 32.
          '';
        };
        js_min_count = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Minimum number of JavaScript runtime instances to allocate. Default 16.
          '';
        };
        js_read_only_globals = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            When enabled, marks all JavaScript runtime globals as read-only to reduce memory footprint. Default true.
          '';
        };
        lua_call_stack_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of each runtime instance's call stack. Default 128.
          '';
        };
        lua_max_count = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum number of Lua runtime instances to allocate. Default 48.
          '';
        };
        lua_min_count = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Minimum number of Lua runtime instances to allocate. Default 16.
          '';
        };
        lua_read_only_globals = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            When enabled, marks all Lua runtime global tables as read-only to reduce memory footprint. Default true.
          '';
        };
        lua_api_stacktrace = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Adds the Lua stack trace in the API response. Default true.
          '';
        };
        lua_registry_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size of each Lua runtime instance's registry. Default 512.
          '';
        };
        max_count = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            (Deprecated) Maximum number of runtime instances to allocate. Default 256.
          '';
        };
        min_count = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            (Deprecated) Minimum number of runtime instances to allocate. Default 16.
          '';
        };
        path = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Path of modules for the server to scan and load at startup. Default value is data_dir/modules.
          '';
        };
        read_only_globals = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            (Deprecated) When enabled, marks all runtime global tables as read-only to reduce memory footprint. Default true.
          '';
        };
        registry_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            (Deprecated) Size of each runtime instance's registry. Default 512.
          '';
        };
      };

      satori = {
        url = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The URL of the Satori instance, in the format: https://<instance>.satoricloud.io:<port>.
          '';
        };
        api_key_name = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The name of the Satori API key.
          '';
        };
        api_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The Satori API key.
          '';
        };
        signing_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The key used to sign Satori session tokens.
          '';
        };
      };

      session = {
        encryption_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The encryption key used to produce the client token. Default value is defaultencryptionkey.
          '';
        };
        token_expiry_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Token expiry in seconds. Default value is 60.
          '';
        };
        refresh_encryption_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The encryption key used to produce the session refresh token. Default value is
            defaultrefreshencryptionkey.
          '';
        };
        refresh_token_expiry_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Refresh token expiry in seconds. Default value is 3600.
          '';
        };
        single_socket = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Only allow one socket per user, older sessions are disconnected. Default false.
          '';
        };
        single_match = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Only allow one match per user, older matches receive a leave. Requires single_socket to enable.
            Default false.
          '';
        };
      };

      social = {
        apple = {
          bundle_id = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Apple Sign In bundle ID.
            '';
          };
        };
        steam = {
          app_id = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Steam App ID.
            '';
          };
          publisher_key = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Steam Publisher Key.
            '';
          };
        };
        facebook_instant_game = {
          app_secret = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Facebook Instant App Secret.
            '';
          };
        };
        facebook_limited_login = {
          app_id = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Facebook Limited Login App ID.
            '';
          };
        };
      };

      socket = {
        address = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The IP address of the interface to listen for client traffic on. Default listen on all available
            addresses/interfaces.
          '';
        };
        idle_timeout_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum amount of time in milliseconds to wait for the next request when keep-alive is enabled.
            Used for HTTP connections. Default value is 60000. Larger values are recommended only for local
            debugging, never in production.
          '';
        };
        max_message_size_bytes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum amount of data in bytes allowed to be read from the client socket per message. Used for
            real-time connections. Default value is 4096.
          '';
        };
        max_request_size_bytes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum amount of data in bytes allowed to be read from clients per request. Used for gRPC and
            HTTP connections.. Default value is 4096.
          '';
        };
        outgoing_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The maximum number of messages waiting to be sent to the client. If this is exceeded the client
            is considered too slow and will disconnect. Used when processing real-time connections. Default
            value is 16.
          '';
        };
        ping_backoff_threshold = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Minimum number of messages received from the client during a single ping period that will delay
            the sending of a ping until the next ping period, to avoid sending unnecessary pings on regularly
            active connections. Default value is 20.
          '';
        };
        ping_period_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Time in milliseconds to wait between client ping messages. This value must be less than the
            pong_wait_ms. Used for real-time connections. Default value is 15000.
          '';
        };
        pong_wait_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Time in milliseconds to wait for a pong message from the client after sending a ping. Used for
            real-time connections. Default value is 25000.
          '';
        };
        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = mdDoc ''
            The port for accepting connections from the client, listening on all interfaces. Default value
            is 7350.
          '';
        };
        protocol = mkOption {
          type = types.enum [ null "tcp" "tcp4" "tcp6" ];
          default = null;
          description = lib.mdDoc ''
            The network protocol to listen for traffic on. Possible values are tcp for both IPv4 and IPv6,
            tcp4 for IPv4 only, or tcp6 for IPv6 only. Default tcp.
          '';
        };
        read_buffer_size_bytes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size in bytes of the pre-allocated socket read buffer. Default 4096.
          '';
        };
        read_timeout_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum duration in milliseconds for reading the entire request. Used for HTTP connections.
            Default value is 10000.
          '';
        };
        server_key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Server key to use to establish a connection to the server. Default value is defaultkey.
          '';
        };
        ssl_certificate = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Path to certificate file if you want the server to use SSL directly. Must also supply
            ssl_private_key. NOT recommended for production use.
          '';
        };
        ssl_private_key = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            Path to private key file if you want the server to use SSL directly. Must also supply
            ssl_certificate. NOT recommended for production use.
          '';
        };
        response_headers = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Additional headers to send to clients with every response. Values are only used if the
            response would not otherwise contain a value for the specified headers.
          '';
        };
        write_buffer_size_bytes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Size in bytes of the pre-allocated socket write buffer. Default 4096.
          '';
        };
        write_timeout_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum duration in milliseconds before timing out writes of the response. Used for HTTP
            connections. Default value is 10000.
          '';
        };
        write_wait_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Time in milliseconds to wait for an ack from the client when writing data. Used for
            real-time connections. Default value is 5000.
          '';
        };
      };

      tracker = {
        event_queue_size = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            Size of the tracker presence event buffer. Increase if the server is expected to generate a large
            number of presence events in a short time. Default value is 1024.
          '';
        };
        broadcast_period_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            [Enterprise Only]
            Time in milliseconds between tracker presence replication broadcasts to each cluster node. Default
            value is 1500.
          '';
        };
        clock_sample_periods = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            Number of broadcasts before a presence transfer will be requested from a cluster node if one is not
            received as expected. Default value is 2.
          '';
        };
        max_delta_sizes = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            [Enterprise Only]
            Number of deltas and maximum presence count per delta for presence snapshots used to broadcast minimal
            subsets of presence data to cluster nodes. Used in periods of frequent presence changes to efficiently
            find the smallest set to sync between nodes. Note that the order of values matters. Default values are
            100, 1000 and 10000.
          '';
        };
        max_silent_periods = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            [Enterprise Only]
            Maximum number of missed broadcasts before a cluster node's presences are considered down. Default value
            is 10.
          '';
        };
        permdown_period_ms = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            [Enterprise Only]
            Time in milliseconds since last broadcast before a cluster node's presences are considered permanently
            down and will be removed. Default value is 1200000.
          '';
        };
      };

      matchmaker = {
        max_tickets = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            Maximum number of concurrent matchmaking tickets allowed per session or party. Default 3.
          '';
        };
        interval_sec = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            How quickly the matchmaker attempts to form matches, in seconds. Default 15.
          '';
        };
        max_intervals = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            How many intervals the matchmaker attempts to find matches at the max player count, before allowing min
            count. Default 2.
          '';
        };
        rev_precision = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Reverse matching precision, i.e. if Player A matches with Player B the matchmaker will also check if
            Player B matches with Player A. Default false.
          '';
        };
        rev_threshold = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = lib.mdDoc ''
            The number of matchmaker intervals to allow reverse matching before falling back to one-way matching.
            Default 1.
          '';
        };
      };

      google_auth = {
        credentials_json = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            The content of the credentials file obtained on Google Console (The JSON file as a string).
          '';
        };
      };
    };
  };
}
