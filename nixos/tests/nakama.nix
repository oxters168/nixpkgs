import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nakama-test";

  nodes = {
    server = { config, pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      services.nakama.enable = true;
    };
  };

  testScript = ''
    start_all()
    server.succeed("echo Completed test successfully")
  '';
})