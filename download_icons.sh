#!/bin/bash
# ============================================================
# UniFi Fingerprint Icon Downloader
# Downloads all device icons from static.ui.com/fingerprint/
# ============================================================
#
# Usage:  ./download_icons.sh [output_dir]
# Default output: ./unifi-icons/
#
# Run on macOS (Nostromo) then scp to OPNsense.
# ============================================================

set -euo pipefail

OUTDIR="${1:-./unifi-icons}"
DB_URL="https://raw.githubusercontent.com/CANTI-BOT/UniFi-Icon-Browser/main/chrome-extension/data/fingerprint-database.json"
ICON_BASE="https://static.ui.com/fingerprint/0"
MAX_ID=9999
CONCURRENT=20
SIZE="257x257"

mkdir -p "${OUTDIR}/images"

echo "============================================"
echo "  UniFi Fingerprint Icon Downloader"
echo "============================================"
echo "Output:     ${OUTDIR}"
echo "Icon size:  ${SIZE}"
echo "Scanning:   IDs 0 to ${MAX_ID}"
echo ""

# ── Step 1: Download fingerprint database ──
echo "=== Downloading fingerprint database ==="
DB_FILE="${OUTDIR}/fingerprint-database.json"

if [ -f "${DB_FILE}" ] && [ -s "${DB_FILE}" ]; then
    # Verify it's valid JSON
    if python3 -c "import json; json.load(open('${DB_FILE}'))" 2>/dev/null; then
        echo "  Already exists and is valid, skipping (delete to re-download)"
    else
        echo "  Existing file is corrupt, re-downloading..."
        rm -f "${DB_FILE}"
    fi
fi

if [ ! -f "${DB_FILE}" ] || [ ! -s "${DB_FILE}" ]; then
    echo "  Fetching from GitHub..."
    HTTP_CODE=$(curl -sS -w "%{http_code}" -o "${DB_FILE}" "${DB_URL}" 2>/dev/null || echo "000")

    if [ "${HTTP_CODE}" = "200" ] && [ -s "${DB_FILE}" ]; then
        echo "  Downloaded OK (HTTP ${HTTP_CODE})"
    else
        echo "  WARNING: Download failed (HTTP ${HTTP_CODE})"
        echo "  Trying alternative: fetching from UniFi-Icon-Browser releases..."

        # Try alternate URL patterns
        ALT_URLS=(
            "https://raw.githubusercontent.com/CANTI-BOT/UniFi-Icon-Browser/refs/heads/main/chrome-extension/data/fingerprint-database.json"
            "https://cdn.jsdelivr.net/gh/CANTI-BOT/UniFi-Icon-Browser@main/chrome-extension/data/fingerprint-database.json"
        )

        DOWNLOADED=0
        for ALT_URL in "${ALT_URLS[@]}"; do
            echo "  Trying: ${ALT_URL}"
            HTTP_CODE=$(curl -sS -L -w "%{http_code}" -o "${DB_FILE}" "${ALT_URL}" 2>/dev/null || echo "000")
            if [ "${HTTP_CODE}" = "200" ] && [ -s "${DB_FILE}" ]; then
                echo "  Downloaded OK from alternate URL"
                DOWNLOADED=1
                break
            fi
        done

        if [ "${DOWNLOADED}" = "0" ]; then
            echo ""
            echo "  ERROR: Could not download fingerprint database from any source."
            echo "  You can manually download it from:"
            echo "    https://github.com/CANTI-BOT/UniFi-Icon-Browser"
            echo "  Save it as: ${DB_FILE}"
            echo ""
            echo "  Continuing without device names (icons will still download)..."
            echo "{}" > "${DB_FILE}"
        fi
    fi
fi

# ── Step 2: Parse database and build lookup ──
echo ""
echo "=== Parsing device database ==="
LOOKUP="${OUTDIR}/id_lookup.txt"

ENTRY_COUNT=$(python3 << 'PYEOF'
import json, re, sys

db_file = sys.argv[1] if len(sys.argv) > 1 else "unifi-icons/fingerprint-database.json"
lookup_file = sys.argv[2] if len(sys.argv) > 2 else "unifi-icons/id_lookup.txt"

try:
    with open(db_file, 'r') as f:
        content = f.read().strip()
        if not content:
            db = {}
        else:
            db = json.loads(content)
except (json.JSONDecodeError, FileNotFoundError) as e:
    print(f"Warning: Could not parse database: {e}", file=sys.stderr)
    db = {}

count = 0
with open(lookup_file, 'w') as out:
    if isinstance(db, dict):
        for dev_id, info in db.items():
            name = ''
            if isinstance(info, str):
                name = info
            elif isinstance(info, dict):
                name = info.get('name', info.get('model', info.get('device_name', '')))
            name = re.sub(r'[^a-zA-Z0-9._-]', '_', name.strip())[:80]
            if name:
                out.write(f'{dev_id}\t{name}\n')
                count += 1
    elif isinstance(db, list):
        for item in db:
            if isinstance(item, dict):
                dev_id = str(item.get('id', item.get('dev_id', '')))
                name = item.get('name', item.get('model', item.get('device_name', '')))
                name = re.sub(r'[^a-zA-Z0-9._-]', '_', str(name).strip())[:80]
                if dev_id and name:
                    out.write(f'{dev_id}\t{name}\n')
                    count += 1

print(count)
PYEOF
"${DB_FILE}" "${LOOKUP}" 2>/dev/null) || ENTRY_COUNT=0

echo "  Found ${ENTRY_COUNT} named devices in database"

# ── Step 3: Download all icons ──
echo ""
echo "=== Downloading device icons ==="
echo "  Scanning IDs 0-${MAX_ID}, ${CONCURRENT} parallel downloads..."
echo "  This may take a few minutes..."
echo ""

# Create a download worker script
WORKER="${OUTDIR}/.worker.sh"
cat > "${WORKER}" << 'WORKEREOF'
#!/bin/bash
ID="$1"
OUTDIR="$2"
ICON_BASE="$3"
SIZE="$4"
LOOKUP="$5"

URL="${ICON_BASE}/${ID}_${SIZE}.png"
TMPFILE="${OUTDIR}/images/.tmp_${ID}.png"

# Download
HTTP_CODE=$(curl -sf -w "%{http_code}" --connect-timeout 5 --max-time 10 -o "${TMPFILE}" "${URL}" 2>/dev/null || echo "000")

if [ "${HTTP_CODE}" = "200" ] && [ -f "${TMPFILE}" ] && [ -s "${TMPFILE}" ]; then
    # Verify it's a real PNG
    MAGIC=$(xxd -l 4 -p "${TMPFILE}" 2>/dev/null || head -c 4 "${TMPFILE}" | od -A n -t x1 | tr -d ' ')
    if echo "${MAGIC}" | grep -qi "89504e47"; then
        # Get device name from lookup
        NAME=""
        if [ -f "${LOOKUP}" ]; then
            NAME=$(grep "^${ID}	" "${LOOKUP}" 2>/dev/null | head -1 | cut -f2)
        fi
        if [ -n "${NAME}" ]; then
            DEST="${OUTDIR}/images/${ID}_${NAME}_${SIZE}.png"
        else
            DEST="${OUTDIR}/images/${ID}_${SIZE}.png"
        fi
        mv "${TMPFILE}" "${DEST}"
        echo "OK"
        exit 0
    fi
fi

rm -f "${TMPFILE}" 2>/dev/null
echo "SKIP"
exit 0
WORKEREOF
chmod +x "${WORKER}"

# Download in parallel batches
FOUND=0
CHECKED=0
ID=0

while [ ${ID} -le ${MAX_ID} ]; do
    # Launch batch
    PIDS=()
    TMPRESULTS=()
    BATCH_END=$((ID + CONCURRENT - 1))
    [ ${BATCH_END} -gt ${MAX_ID} ] && BATCH_END=${MAX_ID}

    for (( I=ID; I<=BATCH_END; I++ )); do
        RESULT_FILE="${OUTDIR}/.result_${I}"
        bash "${WORKER}" "${I}" "${OUTDIR}" "${ICON_BASE}" "${SIZE}" "${LOOKUP}" > "${RESULT_FILE}" 2>/dev/null &
        PIDS+=($!)
        TMPRESULTS+=("${RESULT_FILE}")
    done

    # Wait for batch
    for PID in "${PIDS[@]}"; do
        wait ${PID} 2>/dev/null || true
    done

    # Count results
    for RF in "${TMPRESULTS[@]}"; do
        if [ -f "${RF}" ] && grep -q "OK" "${RF}" 2>/dev/null; then
            FOUND=$((FOUND + 1))
        fi
        rm -f "${RF}" 2>/dev/null
    done

    CHECKED=$((BATCH_END + 1))

    # Progress
    if [ $((CHECKED % 100)) -eq 0 ] || [ ${CHECKED} -gt ${MAX_ID} ]; then
        printf "\r  Checked: %d/%d | Found: %d icons    " ${CHECKED} $((MAX_ID + 1)) ${FOUND}
    fi

    ID=$((BATCH_END + 1))
done

# Cleanup
rm -f "${WORKER}" "${OUTDIR}/.result_"* 2>/dev/null

echo ""
echo ""
echo "============================================"
echo "  DONE!"
echo "============================================"
echo "  Icons downloaded: ${FOUND}"
echo "  Location:         ${OUTDIR}/images/"
echo "  Database:         ${DB_FILE}"
echo ""
echo "  To deploy to OPNsense:"
echo "    cd ${OUTDIR}/images && tar czf /tmp/unifi-icons.tar.gz *.png"
echo "    scp /tmp/unifi-icons.tar.gz root@<opnsense>:/tmp/"
echo "    scp ${DB_FILE} root@<opnsense>:/usr/local/opnsense/www/clientoverview/icons/"
echo ""
echo "  Then on OPNsense:"
echo "    cd /usr/local/opnsense/www/clientoverview/icons && tar xzf /tmp/unifi-icons.tar.gz"
echo ""
