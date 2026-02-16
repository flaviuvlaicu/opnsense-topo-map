#!/bin/sh
echo "=== Looking for compiled volt cache ==="
find /tmp -name "*.php" -path "*volt*" -o -name "*.php" -path "*Phalcon*" 2>/dev/null | head -20

echo ""
echo "=== Looking for ClientOverview in cached files ==="
grep -rl "ClientOverview\|client-overview\|clientoverview" /tmp/ 2>/dev/null | head -10

echo ""
echo "=== OPNsense volt cache locations ==="
find /tmp -type d -name "volt" 2>/dev/null
find /tmp -type d -name "Phalcon" 2>/dev/null
find /var -type d -name "volt" 2>/dev/null

echo ""
echo "=== Check if volt file was actually updated ==="
ls -la /usr/local/opnsense/mvc/app/views/OPNsense/ClientOverview/index.volt
echo ""
echo "=== First 5 lines of CSS in the volt file (should show border-radius:50%) ==="
grep "border-radius:50%" /usr/local/opnsense/mvc/app/views/OPNsense/ClientOverview/index.volt | head -3
echo ""
echo "=== Check for old square style ==="
grep "border-radius:10px" /usr/local/opnsense/mvc/app/views/OPNsense/ClientOverview/index.volt | head -3
