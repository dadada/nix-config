{ pkgs
, declInput
, projectName
, ...
}:
pkgs.runCommand "spec.json" { } ''
  cat <<EOF
  ${builtins.toXML declInput}
  EOF
  cat > $out <<EOF
  {
      "main": {
          "enabled": 1,
          "hidden": false,
          "description": "${projectName}",
          "flakeuri": "github:dadada/nix-config/main",
          "checkinterval": 300,
          "schedulingshares": 1,
          "enableemail": false,
          "emailoverride": "",
          "keepnr": 3,
          "type": "flake",
          "inputs": ${builtins.toJSON declInput}
      }
  }
  EOF
''
