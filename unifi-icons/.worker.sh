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
