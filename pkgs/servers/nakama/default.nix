{ lib, stdenv, fetchFromGitHub, nixosTests, go }:

stdenv.mkDerivation rec {
	pname = "nakama";
	version = "3.19.0";

	src = (fetchFromGitHub {
		owner = "heroiclabs";
		repo = pname;
		rev = "v${version}";
		hash = "sha256-x5gT/mYVaYdeor+U37z1MjJ6zmb7yep/2tVJYgGXPYo=";
	});

	# when using goBuildModule, I get an error saying it could not find openapi-gen-angular even though it exists as a sub-module
	# so I opted to manually build using the recommended command from heroiclab's github
	buildInputs = [go];
	buildPhase = ''
		GOCACHE=$(pwd) go build -trimpath -mod=vendor 
	'';

	installPhase = ''
		mkdir -p $out/bin
		cp nakama $out/bin
	'';

#   # need to copy in the systemd units for systemd.packages to discover them
#   postInstall = ''
#     install -Dm444 -t $out/lib/systemd/system/ systemd/nakama.{service,socket}
#   '';

	meta = with lib; {
		description = "The popular open-source game server";
		homepage = "https://heroiclabs.com/nakama/";
		changelog = "https://github.com/heroiclabs/nakama/blob/v${version}/CHANGELOG.md";
		license = lib.licenses.asl20;
		maintainers = with lib.maintainers; [ Oxters ];
	};
}
