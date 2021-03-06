let
    pkgsMake = import ../../pkgs-make;
    pkgsMakeArgs = {};
in

pkgsMake pkgsMakeArgs ({ call, lib, ... }: rec {

    example-python-lib = call.python ./library;

    example-python-app = call.python ./application;

    example-python-docker = lib.nix.dockerTools.buildImage {
        name = "example-python";
        contents = example-python-app;
        config = {
            ExposedPorts = { "8080/tcp" = {}; };
            Entrypoint = [ "/bin/example-python" ];
        };
    };

    example-python-tarball =
        lib.nix.tarball example-python-app "example-python.tar";

    example-python-licenses = lib.nix.license-report.json {
        inherit example-python-app;
    };

})