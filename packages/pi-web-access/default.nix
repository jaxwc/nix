{
  buildNpmPackage,
  runCommand,
  src,
}: let
  manifest = builtins.fromJSON (builtins.readFile "${src}/package.json");

  # Upstream's lockfile includes peer-package entries without integrity hashes,
  # which Nix's npm dependency fetcher cannot parse. Use a peer-free lockfile.
  patchedSource = runCommand "pi-web-access-source-${manifest.version}" {} ''
    mkdir -p "$out"
    cp -R ${src}/. "$out/"
    chmod -R u+w "$out"
    cp ${./package-lock.json} "$out/package-lock.json"
  '';
in
  buildNpmPackage {
    pname = "pi-web-access";
    inherit (manifest) version;
    src = patchedSource;
    npmDepsHash = "sha256-ys71QL7qol1D+oBHLL11EmgjuLOPkSPk6pGZWg+0ILo=";
    npmInstallFlags = ["--omit=peer" "--legacy-peer-deps"];
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R . "$out/"
      runHook postInstall
    '';
  }
