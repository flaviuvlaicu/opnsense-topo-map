#!/bin/sh
set -e
echo "Uninstalling Client Overview plugin..."
rm -rf /usr/local/opnsense/mvc/app/controllers/OPNsense/ClientOverview
rm -rf /usr/local/opnsense/mvc/app/models/OPNsense/ClientOverview
rm -rf /usr/local/opnsense/mvc/app/views/OPNsense/ClientOverview
rm -rf /usr/local/opnsense/scripts/clientoverview
rm -f  /usr/local/opnsense/service/conf/actions.d/actions_clientoverview.conf
rm -f  /usr/local/etc/inc/plugins.inc.d/clientoverview.inc
rm -f  /usr/local/www/clientoverview 2>/dev/null || true
# Keep icons dir for reinstall, pass --purge to remove everything
if [ "$1" = "--purge" ]; then
    rm -rf /usr/local/opnsense/www/clientoverview
    echo "Icons removed."
else
    echo "Icons kept at /usr/local/opnsense/www/clientoverview/icons/"
    echo "Use 'sh uninstall.sh --purge' to remove everything including icons."
fi
service configd restart
echo "Done."
