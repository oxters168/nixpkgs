import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nakama-test";

  nodes = {
    server = { config, pkgs, ... }: {
      services.nakama.enable = true;
    };
  };

  testScript = ''
    start_all()
    server.succeed("echo this runs on server")
  '';
})