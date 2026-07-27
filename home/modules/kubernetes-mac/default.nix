{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    colima
    kubectl
    docker-client
    docker-compose
    docker-credential-helpers
    kubernetes-helm
    k9s
  ];

  # create or update ~/.docker/config.json with credsStore = osxkeychain
  home.activation.dockerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.docker"

    dockerConfig="${config.home.homeDirectory}/.docker/config.json"

    if [ -f "$dockerConfig" ]; then
      $DRY_RUN_CMD ${pkgs.jq}/bin/jq '. * {"credsStore": "osxkeychain"}' "$dockerConfig" > "$dockerConfig.tmp"
      $DRY_RUN_CMD mv "$dockerConfig.tmp" "$dockerConfig"
    else
      $DRY_RUN_CMD ${pkgs.jq}/bin/jq -n '{"credsStore": "osxkeychain"}' > "$dockerConfig"
    fi
  '';
}
