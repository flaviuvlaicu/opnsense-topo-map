# OPNsense Client Overview Plugin v2

A **UniFi Network-style** client dashboard for OPNsense. Shows all connected devices
in a clean list with a detail panel, custom icons, and device classification.

## Features

- **UniFi-style layout** — device list on the left, detail panel on the right
- **Custom icons per device** — click the device icon to upload your own PNG/SVG/JPG
- **Custom device names** — set an alias for any device (saved per MAC address)
- **Editable device type** — override the auto-detected type (phone, laptop, IoT, etc.)
- **Online/offline status** — green dot for online (ARP-detected), grey for offline
- **MAC OUI vendor lookup** — shows manufacturer from MAC address prefix
- **Kea DHCP integration** — reads leases directly from Kea's CSV lease file
- **Search and filter** — search by name/IP/MAC/vendor, filter by online/offline
- **Auto-refresh** — updates every 30 seconds
- **Persisted settings** — custom names, icons, and types saved in JSON file

## Installation

```bash
scp os-client-overview.tar.gz root@your-opnsense:/tmp/
ssh root@your-opnsense
cd /tmp && tar xzf os-client-overview.tar.gz && cd os-client-overview && sh install.sh
```

Then go to **Services > Client Overview** in the OPNsense GUI.

## Custom Icons

1. Click any device in the list to open the detail panel
2. Hover over the device icon — you'll see "Change Icon"
3. Click it and select a PNG, SVG, JPG, or WebP image
4. The icon is saved per MAC address and persists across reboots

Icons are stored in `/usr/local/opnsense/www/clientoverview/icons/`.

## Custom Names & Types

- In the detail panel, use the **Alias** field to set a friendly name
- Use the **Device Type** dropdown to override the auto-detected category
- Settings are stored in `/usr/local/opnsense/scripts/clientoverview/custom_devices.json`

## Uninstall

```bash
cd /tmp/os-client-overview && sh uninstall.sh
```
