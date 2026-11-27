#!/usr/bin/env bash
# Creates the eduroam NetworkManager connection (system-wide, password stored in the profile).
# Run this first on a new machine, since you need eduroam for the internet that the first rebuild needs.
# Replaces the cat.eduroam.org installer, which does not store the password correctly.
set -euo pipefail

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
CA_SRC="$SCRIPT_DIR/eduroam-ca.pem"
# Must be under /etc (or /nix/store): the NixOS wpa_supplicant service is sandboxed and cannot see other paths
CA_DEST=/etc/eduroam/ca.pem

# Sikt/Uninett settings. Change these for another institution.
ANONYMOUS_IDENTITY=anonym@sikt.no
DOMAIN_MATCH=eduroam.uninett.no

read -r -p "eduroam identity (e.g. your.name@institution.no): " identity
read -r -s -p "eduroam password: " password
echo

# The CA cert must stay at this path, since wpa_supplicant reads it on every connect
sudo install -D -m 644 "$CA_SRC" "$CA_DEST"

# Remove any existing eduroam connection (e.g. from the cat.eduroam.org installer) to avoid duplicates
while sudo nmcli -t -f NAME connection show | grep -qx eduroam; do
	sudo nmcli connection delete eduroam > /dev/null
done

# Created through nmcli (NetworkManager's own API) as root, so it is system-wide and the password is stored in the
# root-only profile (password-flags 0). Note: the password is briefly visible in the process list while this runs.
sudo nmcli connection add type wifi con-name eduroam ssid eduroam \
	wifi-sec.key-mgmt wpa-eap \
	802-1x.eap ttls \
	802-1x.phase2-auth pap \
	802-1x.anonymous-identity "$ANONYMOUS_IDENTITY" \
	802-1x.identity "$identity" \
	802-1x.ca-cert "$CA_DEST" \
	802-1x.domain-match "$DOMAIN_MATCH" \
	802-1x.password-flags 0 \
	802-1x.password "$password"

echo "eduroam connection created. Connect with: nmcli connection up eduroam"
