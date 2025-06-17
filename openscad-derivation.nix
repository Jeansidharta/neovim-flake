{
  lib,
  rustPlatform,
  openscad-lsp,
}:
rustPlatform.buildRustPackage {
  pname = "openscad-lsp";
  version = "2.0.1";
  src = openscad-lsp;
  useFetchCargoVendor = true;
  cargoHash = "sha256-2L3LBwcCsNMXaLYbs9j2aOnfqTPudRGWTcw5pwmtdxQ=";
  # no tests exist
  doCheck = false;

  meta = with lib; {
    description = "A LSP (Language Server Protocol) server for OpenSCAD";
    mainProgram = "openscad-lsp";
    homepage = "https://github.com/Leathong/openscad-LSP";
    license = licenses.asl20;
  };
}
