# OPNsense Client Overview Plugin v12.2

A **UniFi Network-style** client dashboard and network topology editor for OPNsense.

## Features

### Clients Tab
- **Device list** with online/offline status, IP, MAC, VLAN, vendor, device type
- **Detail panel** — click any device for full info, alias editing, icon browser, WoL
- **Auto-classification** — 100+ hostname and vendor rules detect phones, laptops, IoT, smart home, etc.
- **Fingerprint icons** — 5,000+ real product images from UniFi's device database
- **Custom icons** — upload PNG/SVG/JPG/WebP per device, or pick from the icon browser
- **Custom names** — set aliases per device (saved by MAC address)
- **Search & filter** — search by name/IP/MAC/vendor, filter by type/online/offline
- **Sort** — click column headers to sort by name, IP, VLAN, type, or vendor
- **VLAN detection** — auto-detects VLANs from Kea DHCP subnets, shows VLAN column and names
- **Wake-on-LAN** — send magic packets to offline devices (broadcasts to all subnets)
- **Forget device** — remove stale devices from all lists and topology
- **Randomized MAC detection** — badges devices using random/private MACs
- **First/Last seen** — tracks when devices were first and last observed
- **Known devices persistence** — offline devices remembered for 30 days
- **Auto-refresh** — polls every 30 seconds

### Topology Tab
- **Drag-and-drop network map** — build your network topology visually
- **Auto-layout** — automatic tree layout with row wrapping (max 8 per row)
- **Parent/child relationships** — drag devices onto switches/routers to set hierarchy
- **Port labels** — name switch ports, click to rename
- **Link speed labels** — set connection speeds (100M, 1G, 2.5G, 5G, 10G, etc.)
- **VLAN color coding** — lines and badges colored by VLAN, customizable via color picker
- **Lasso select** — click-drag on empty canvas to select multiple nodes
- **Group drag** — move selected nodes together
- **Ctrl+A** — select all visible nodes
- **Ctrl+S** — save topology
- **Delete/Backspace** — remove selected nodes
- **Escape** — deselect all, close panels
- **?** — keyboard shortcuts overlay
- **Filters** — infrastructure only, wired only, online only
- **WiFi AP detection** — identifies access points by hostname/vendor patterns
- **Unsaved changes warning** — browser prompt on close/tab switch with dirty topology
- **Orphan pruning** — auto-removes stale nodes on save
- **Sidebar** — all devices listed with drag-to-canvas placement, search, VLAN grouping
- **Topology path** — detail panel shows full path from root to selected device

## Installation

```bash
scp os-client-overview.tar.gz root@your-opnsense:/tmp/
ssh root@your-opnsense
cd /tmp && tar xzf os-client-overview.tar.gz && cd os-client-overview && sh install.sh
```

Then go to **Services > Client Overview** in the OPNsense GUI.

## Device Icons (Optional)

Download ~5,000 real product images from the UniFi fingerprint database:

```bash
# On any machine with internet access:
sh download_icons.sh

# Copy to OPNsense:
scp -r icons/* root@your-opnsense:/usr/local/opnsense/www/clientoverview/icons/
```

Without icons, devices show generic SVG icons by type. With icons, you get actual product renders (iPhone looks like an iPhone, Synology NAS looks like the real box, etc.)

## Uninstall

```bash
ssh root@your-opnsense
sh /tmp/os-client-overview/uninstall.sh          # keeps icons
sh /tmp/os-client-overview/uninstall.sh --purge   # removes everything
```

## File Locations

| File | Purpose |
|------|---------|
| `/usr/local/opnsense/scripts/clientoverview/list_clients.py` | Backend: device discovery, classification, WoL |
| `/usr/local/opnsense/scripts/clientoverview/custom_devices.json` | Persisted custom names, icons, types |
| `/usr/local/opnsense/scripts/clientoverview/known_devices.json` | Known devices with first/last seen |
| `/usr/local/opnsense/scripts/clientoverview/topology.json` | Saved topology layout |
| `/usr/local/opnsense/www/clientoverview/icons/` | Fingerprint + custom icons |

## Requirements

- OPNsense 23.x+ with Kea DHCP
- Python 3 (included with OPNsense)
- No additional packages required
