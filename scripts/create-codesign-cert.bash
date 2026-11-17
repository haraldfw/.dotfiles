#!/usr/bin/env bash
# Creates a local self-signed code-signing identity used to re-sign Nix-built apps
# (see home/modules/codesign-apps) so macOS privacy permissions survive rebuilds.
# Run once per machine.
set -euo pipefail

NAME="nixbook-codesign"
KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"

if security find-identity -v -p codesigning | grep -q "\"$NAME\""; then
  echo "Identity '$NAME' already exists"
  exit 0
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# needs OpenSSL 3 (for -legacy), prefer the homebrew one over macOS' LibreSSL
if [[ -x /opt/homebrew/bin/openssl ]]; then
  OPENSSL=/opt/homebrew/bin/openssl
else
  OPENSSL=openssl
fi

"$OPENSSL" req -x509 -newkey rsa:2048 -nodes -days 3650 -subj "/CN=$NAME" \
  -addext "keyUsage=critical,digitalSignature" \
  -addext "extendedKeyUsage=critical,codeSigning" \
  -keyout "$TMP/key.pem" -out "$TMP/cert.pem"

# -legacy: macOS' security tool can't read OpenSSL 3's default p12 encryption
"$OPENSSL" pkcs12 -export -legacy -inkey "$TMP/key.pem" -in "$TMP/cert.pem" \
  -name "$NAME" -out "$TMP/id.p12" -passout pass:tmp

# -T: let codesign use the key without a keychain prompt
security import "$TMP/id.p12" -k "$KEYCHAIN" -P tmp -T /usr/bin/codesign

echo "Trusting the certificate for code signing (asks for your password)..."
security add-trusted-cert -r trustRoot -p codeSign -k "$KEYCHAIN" "$TMP/cert.pem"

security find-identity -v -p codesigning | grep "$NAME"
