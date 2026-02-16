#!/bin/sh
set -e

echo "========================================="
echo " Client Overview Plugin v12 — Installer"
echo "========================================="

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run as root."; exit 1
fi

BASEDIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${BASEDIR}/src"

echo "[1/8] Controllers..."
mkdir -p /usr/local/opnsense/mvc/app/controllers/OPNsense/ClientOverview/Api
cp "${SRC}/opnsense/mvc/app/controllers/OPNsense/ClientOverview/IndexController.php" \
   /usr/local/opnsense/mvc/app/controllers/OPNsense/ClientOverview/
cp "${SRC}/opnsense/mvc/app/controllers/OPNsense/ClientOverview/Api/ServiceController.php" \
   /usr/local/opnsense/mvc/app/controllers/OPNsense/ClientOverview/Api/

echo "[2/8] Models..."
mkdir -p /usr/local/opnsense/mvc/app/models/OPNsense/ClientOverview/Menu
mkdir -p /usr/local/opnsense/mvc/app/models/OPNsense/ClientOverview/ACL
cp "${SRC}/opnsense/mvc/app/models/OPNsense/ClientOverview/Menu/Menu.xml" \
   /usr/local/opnsense/mvc/app/models/OPNsense/ClientOverview/Menu/Menu.xml
cp "${SRC}/opnsense/mvc/app/models/OPNsense/ClientOverview/ACL/ACL.xml" \
   /usr/local/opnsense/mvc/app/models/OPNsense/ClientOverview/ACL/ACL.xml

echo "[3/8] Views..."
mkdir -p /usr/local/opnsense/mvc/app/views/OPNsense/ClientOverview
cp "${SRC}/opnsense/mvc/app/views/OPNsense/ClientOverview/index.volt" \
   /usr/local/opnsense/mvc/app/views/OPNsense/ClientOverview/

echo "[4/8] Backend script..."
mkdir -p /usr/local/opnsense/scripts/clientoverview
cp "${SRC}/opnsense/scripts/clientoverview/list_clients.py" \
   /usr/local/opnsense/scripts/clientoverview/
chmod +x /usr/local/opnsense/scripts/clientoverview/list_clients.py

# Preserve user data files across reinstalls
for f in topology.json custom_devices.json known_devices.json vendor_cache.json; do
    if [ -f "/usr/local/opnsense/scripts/clientoverview/$f" ]; then
        chown root:wheel "/usr/local/opnsense/scripts/clientoverview/$f"
        echo "  -> Preserved $f"
    fi
done

echo "[5/8] Icons directory..."
# Create icons dir (preserves existing icons on reinstall)
mkdir -p /usr/local/opnsense/www/clientoverview/icons
chown -R www:www /usr/local/opnsense/www/clientoverview
# Clean macOS resource fork files if present
find /usr/local/opnsense/www/clientoverview/icons -name '._*' -delete 2>/dev/null || true

echo "[6/8] Web server symlink..."
# lighttpd needs this symlink to serve static icon files
if [ ! -L /usr/local/www/clientoverview ]; then
    rm -rf /usr/local/www/clientoverview
    ln -s /usr/local/opnsense/www/clientoverview /usr/local/www/clientoverview
    echo "  -> Created symlink: /usr/local/www/clientoverview"
else
    echo "  -> Symlink already exists"
fi

echo "[7/8] Configd action..."
cp "${SRC}/opnsense/service/conf/actions.d/actions_clientoverview.conf" \
   /usr/local/opnsense/service/conf/actions.d/

echo "[8/8] Plugin registration..."
cp "${SRC}/etc/inc/plugins.inc.d/clientoverview.inc" \
   /usr/local/etc/inc/plugins.inc.d/

# Clear stale caches
rm -f /usr/local/opnsense/scripts/clientoverview/fp_match_cache.json 2>/dev/null || true

# IMPORTANT: Clear OPNsense's compiled Volt template cache
# Without this, the old compiled template keeps getting served
rm -f /tmp/Phalcon/volt/*.php 2>/dev/null || true
rm -f /tmp/Phalcon/volt/**/*.php 2>/dev/null || true
find /tmp -path "*/Phalcon/volt*" -name "*.php" -delete 2>/dev/null || true
echo "  -> Cleared Volt template cache"

echo ""
echo "Restarting configd..."
service configd restart

echo ""
echo "========================================="
echo " Done! Open: Services > Client Overview"
echo "========================================="
echo ""
echo " Features:"
echo "  - Real product images from UniFi fingerprint database"
echo "  - Click device icon to browse 5,000+ device icons"
echo "  - Upload custom icons for any device"
echo "  - Set custom names (aliases) per device"
echo "  - Auto-refreshes every 30 seconds"
echo ""
echo " To add device icons (one-time setup):"
echo "   1. On any machine with internet: sh download_icons.sh"
echo "   2. Copy to OPNsense:"
echo "      scp fingerprint-database.json root@opnsense:/usr/local/opnsense/www/clientoverview/icons/"
echo "      tar czf icons.tar.gz *.png && scp icons.tar.gz root@opnsense:/tmp/"
echo "      ssh root@opnsense 'cd /usr/local/opnsense/www/clientoverview/icons && tar xzf /tmp/icons.tar.gz'"
echo "========================================="
