#!/bin/bash
# Prefer IPv4 and disable broken IPv6 on house MagicMirror Pis.
# Run: bash ~/magicmirror-house-setup/scripts/fix-ipv4-on-pi.sh
set -euo pipefail

echo "==> Prefer IPv4 in getaddrinfo (gai.conf)"
if ! grep -q '^precedence :ffff:0:0/96' /etc/gai.conf 2>/dev/null; then
	echo 'precedence :ffff:0:0/96  100' | sudo tee -a /etc/gai.conf >/dev/null
fi

echo "==> Disable IPv6 (persist across reboot)"
sudo tee /etc/sysctl.d/99-disable-ipv6.conf >/dev/null <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sudo sysctl --system >/dev/null

echo "==> Wi-Fi powersave off (NetworkManager)"
sudo tee /etc/NetworkManager/conf.d/powersave.conf >/dev/null <<'EOF'
[connection]
wifi.powersave=2
EOF
sudo systemctl restart NetworkManager

echo "==> Done. disable_ipv6 should be 1:"
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
echo "Restart MagicMirror if it is already running:"
echo "  systemctl --user restart magicmirror.service"
