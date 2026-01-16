{
    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs =
        {
            self,
            nixpkgs,
            flake-utils,
        }:
        flake-utils.lib.eachDefaultSystem (
            system:
            let
                pkgs = nixpkgs.legacyPackages.${system};
                rs-python = pkgs.python312.withPackages (
                    ps: with ps; [
                        numpy
                        pandas
                        tensorflow-bin
                        (keras.override {
                            tensorflow = tensorflow-bin;
                        })
                        rdkit

                        notebook
                        ipykernel
                        ipywidgets
                    ]
                );
            in
            with pkgs;
            {
                devShells.default = mkShell {
                    buildInputs = [
                        wget

                        rs-python
                        jupyter-all
                    ];
                };
            }
        );
}
