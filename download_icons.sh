#!/bin/sh
# Download UniFi fingerprint device icons for OPNsense Client Overview
# Run this on any machine with internet access, then copy icons to OPNsense.
#
# Usage:
#   sh download_icons.sh
#   # Then copy to OPNsense:
#   scp -r icons/* root@<opnsense-ip>:/usr/local/opnsense/www/clientoverview/icons/

set -e

ICONS_DIR="./icons"
DB_URL="https://static.ui.com/fingerprint/ui/icons"
DB_JSON_URL="https://static.ui.com/fingerprint/ui/fingerprint-database.json"

mkdir -p "$ICONS_DIR"

echo "=== Downloading fingerprint database ==="
curl -sL "$DB_JSON_URL" -o "$ICONS_DIR/fingerprint-database.json"

count=$(python3 -c "import json;d=json.load(open('$ICONS_DIR/fingerprint-database.json'));print(len(d))" 2>/dev/null || echo "?")
echo "Found $count device entries in database"

echo ""
echo "=== Downloading device icons ==="
echo "This may take a few minutes..."

downloaded=0
failed=0

python3 << 'PYEOF'
import json, os, urllib.request, sys

db_file = os.path.join("./icons", "fingerprint-database.json")
icons_dir = "./icons"

with open(db_file, 'r') as f:
    db = json.load(f)

base_url = "https://static.ui.com/fingerprint/ui/icons"
total = len(db)
downloaded = 0
skipped = 0
failed = 0

for i, (fp_id, fp_name) in enumerate(sorted(db.items(), key=lambda x: x[1])):
    # Build filename: id_Name_257x257.png
    safe_name = fp_name.replace('/', '_').replace(' ', '_').replace('(', '').replace(')', '')
    filename = f"{fp_id}_{safe_name}_257x257.png"
    filepath = os.path.join(icons_dir, filename)

    if os.path.exists(filepath) and os.path.getsize(filepath) > 100:
        skipped += 1
        continue

    url = f"{base_url}/{fp_id}_257x257.png"
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'OPNsense-ClientOverview/12'})
        resp = urllib.request.urlopen(req, timeout=10)
        data = resp.read()
        if len(data) > 100:
            with open(filepath, 'wb') as f:
                f.write(data)
            downloaded += 1
        else:
            failed += 1
    except Exception as e:
        failed += 1

    if (i + 1) % 100 == 0:
        sys.stdout.write(f"\r  Progress: {i+1}/{total} (downloaded: {downloaded}, skipped: {skipped}, failed: {failed})")
        sys.stdout.flush()

print(f"\r  Done: {downloaded} downloaded, {skipped} already existed, {failed} failed, {total} total")
PYEOF

echo ""
echo "=== Complete ==="
echo ""
echo "Icons saved to: $ICONS_DIR/"
echo ""
echo "To install on OPNsense, run:"
echo "  scp -r icons/* root@<opnsense-ip>:/usr/local/opnsense/www/clientoverview/icons/"
echo ""
echo "Or if you prefer tar:"
echo "  cd icons && tar czf ../client-overview-icons.tar.gz * && cd .."
echo "  scp client-overview-icons.tar.gz root@<opnsense-ip>:/tmp/"
echo "  ssh root@<opnsense-ip> 'cd /usr/local/opnsense/www/clientoverview/icons && tar xzf /tmp/client-overview-icons.tar.gz'"
