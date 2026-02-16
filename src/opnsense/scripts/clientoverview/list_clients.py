#!/usr/local/bin/python3
"""
Client Overview v12 - Device classification, fingerprint icons, WoL.
"""

import json, csv, os, subprocess, re, time, glob, sys, ipaddress

KEA_LEASE4_FILE = '/var/db/kea/kea-leases4.csv'
KEA_LEASE4_FILE_ALT = '/var/lib/kea/dhcp4.leases'
OUI_JSON = '/tmp/oui.txt.json'
OUI_NMAP = '/usr/local/share/nmap/nmap-mac-prefixes'
CUSTOM_FILE = '/usr/local/opnsense/scripts/clientoverview/custom_devices.json'
VENDOR_CACHE = '/usr/local/opnsense/scripts/clientoverview/vendor_cache.json'
KNOWN_DEVICES_FILE = '/usr/local/opnsense/scripts/clientoverview/known_devices.json'
ICON_DIR = '/usr/local/opnsense/www/clientoverview/icons'
FP_DB_FILE = os.path.join(ICON_DIR, 'fingerprint-database.json')


# ═══════════════════════════════════════════════════════
# Hostname rules: (pattern, type, product, fp_search)
# ═══════════════════════════════════════════════════════
HOSTNAME_RULES = [
    (r'iphone',                           'phone',      'iPhone',             ['Apple iPhone']),
    (r'ipad[\-_ ]?pro',                  'tablet',     'iPad Pro',           ['Apple iPad Pro']),
    (r'ipad[\-_ ]?air',                  'tablet',     'iPad Air',           ['Apple iPad Air']),
    (r'ipad[\-_ ]?mini',                 'tablet',     'iPad Mini',          ['Apple iPad Mini']),
    (r'ipad',                             'tablet',     'iPad',               ['Apple iPad']),
    (r'macbook[\-_ ]?pro',              'laptop',     'MacBook Pro',        ['Apple MacBook Pro']),
    (r'macbook[\-_ ]?air',              'laptop',     'MacBook Air',        ['Apple MacBook Air']),
    (r'macbook',                          'laptop',     'MacBook',            ['Apple MacBook']),
    (r'imac[\-_ ]?pro',                  'desktop',    'iMac Pro',           ['Apple iMac Pro']),
    (r'imac',                             'desktop',    'iMac',               ['Apple iMac']),
    (r'mac[\-_ ]?mini',                  'desktop',    'Mac Mini',           ['Apple Mac Mini']),
    (r'mac[\-_ ]?pro',                   'desktop',    'Mac Pro',            ['Apple Mac Pro']),
    (r'mac[\-_ ]?studio',                'desktop',    'Mac Studio',         ['Apple Mac Studio']),
    (r'apple[\-_ ]?tv',                  'mediaplayer','Apple TV',           ['Apple TV']),
    (r'homepod[\-_ ]?mini',              'speaker',    'HomePod Mini',       ['Apple HomePod Mini']),
    (r'homepod|apple[\-_ ]?home',        'speaker',    'Apple HomePod',      ['Apple HomePod']),
    (r'^watch|apple[\-_ ]?watch',        'watch',      'Apple Watch',        ['Apple Watch']),
    (r'airpods',                          'audio',      'AirPods',            ['Apple AirPods']),
    (r'homey[\-_ ]?pro|homey[\-_ ]?wired','hub',       'Athom Homey Pro',   ['Athom Homey Pro']),
    (r'homey[\-_ ]?wifi',                'hub',        'Athom Homey',        ['Homey Athom']),
    (r'homey',                            'hub',        'Athom Homey',        ['Homey Athom']),
    (r'hue[\-_ ]?bridge|philips[\-_ ]?bridge|philips[\-_ ]?hue', 'hub', 'Philips Hue Bridge', ['Philips Hue Bridge']),
    (r'ikea[\-_ ]?bridge|tradfri|dirigera', 'hub',     'IKEA DIRIGERA',      ['IKEA Tradfri Hub']),
    (r'tedee',                            'hub',        'Tedee Bridge',       ['Tedee']),
    (r'airthings',                        'sensor',     'Airthings',          ['Airthings']),
    (r'netatmo',                          'sensor',     'Netatmo',            ['Netatmo']),
    (r'dyson',                            'appliance',  'Dyson',              ['Dyson']),
    (r'la[\-_ ]?marzocco|lamarzocco',    'appliance',  'La Marzocco',        ['La Marzocco', 'Coffee Machine']),
    (r'roomba|irobot',                    'appliance',  'iRobot Roomba',      ['iRobot Roomba']),
    (r'roborock',                         'appliance',  'Roborock',           ['Roborock']),
    (r'shelly',                           'plug',       'Shelly',             ['Shelly']),
    (r'sonoff',                           'plug',       'Sonoff',             ['Sonoff']),
    (r'tasmota',                          'plug',       'Tasmota',            ['Smart Plug']),
    (r'esp[\-_ ]|esp32|esp8266',          'plug',       'ESP Device',         ['ESP']),
    (r'tuya',                             'plug',       'Tuya',               ['Tuya']),
    (r'meross',                           'plug',       'Meross',             ['Meross']),
    (r'holo[\-_ ]?red|holo',             'plug',       'Holo Device',        ['Smart Plug']),
    (r'nest[\-_ ]?cam',                  'camera',     'Nest Cam',           ['Nest Cam']),
    (r'nest[\-_ ]?thermostat',           'thermostat', 'Nest Thermostat',    ['Nest Thermostat']),
    (r'nest',                             'iot',        'Google Nest',        ['Nest']),
    (r'ecobee',                           'thermostat', 'ecobee',            ['Ecobee']),
    (r'tado',                             'thermostat', 'tado°',             ['Tado']),
    (r'ring[\-_ ]?doorbell',             'camera',     'Ring Doorbell',      ['Ring Doorbell']),
    (r'ring[\-_ ]',                       'camera',     'Ring',               ['Ring']),
    (r'samsung[\-_ ]?tv',                'tv',         'Samsung TV',         ['Samsung SmartTV']),
    (r'lg[\-_ ]?tv|lg[\-_ ]?web|webos',  'tv',         'LG TV',              ['LG TV']),
    (r'sony[\-_ ]?tv|bravia',            'tv',         'Sony TV',            ['Sony TV']),
    (r'tcl[\-_ ]?tv|^tcl\b',             'tv',         'TCL TV',             ['TCL TV']),
    (r'roku',                             'mediaplayer','Roku',               ['Roku']),
    (r'fire[\-_ ]?tv|fire[\-_ ]?stick',  'mediaplayer','Amazon Fire TV',     ['Amazon Fire TV']),
    (r'chromecast',                       'mediaplayer','Chromecast',         ['Google Chromecast']),
    (r'shield',                           'mediaplayer','NVIDIA Shield',      ['NVIDIA Shield']),
    (r'sonos',                            'speaker',    'Sonos',              ['Sonos']),
    (r'echo[\-_ ]?dot',                  'speaker',    'Amazon Echo Dot',    ['Amazon Echo Dot']),
    (r'echo|alexa',                       'speaker',    'Amazon Echo',        ['Amazon Echo']),
    (r'google[\-_ ]?home',               'speaker',    'Google Home',        ['Google Home']),
    (r'ps5',                              'gaming',     'PlayStation 5',      ['Sony PlayStation 5']),
    (r'ps4|playstation',                  'gaming',     'PlayStation',        ['Sony PlayStation']),
    (r'xbox',                             'gaming',     'Xbox',               ['Xbox']),
    (r'switch|nintendo',                  'gaming',     'Nintendo Switch',    ['Nintendo Switch']),
    # UniFi devices
    (r'unifi[\-_ ]?cloud[\-_ ]?key|uck', 'network',    'UniFi Cloud Key',    ['UniFi Cloud Key']),
    (r'uvc[\-_ ]?g4[\-_ ]?doorbell',     'camera',     'UniFi G4 Doorbell',  ['UniFi G4 Doorbell', 'UniFi Protect G4']),
    (r'uvc|unifi[\-_ ]?protect|unifi[\-_ ]?cam', 'camera', 'UniFi Camera',  ['UniFi Protect']),
    (r'unifi[\-_ ]?udb',                 'camera',     'UniFi Doorbell',     ['UniFi Doorbell']),
    (r'u[56]g[\-_ ]?max|unifi[\-_ ]?ap[\-_ ]?.*max', 'network', 'UniFi AP', ['UniFi U6', 'UniFi AP']),
    (r'usw[\-_ ]?flex[\-_ ]?xg',        'network',    'UniFi Switch',       ['UniFi Switch Flex XG', 'USW Flex']),
    (r'usw[\-_ ]?pro',                   'network',    'UniFi Switch Pro',   ['UniFi Switch Pro', 'USW Pro']),
    (r'usw|unifi[\-_ ]?switch',          'network',    'UniFi Switch',       ['UniFi Switch', 'USW']),
    (r'unifi[\-_ ]?ai[\-_ ]?port',      'network',    'UniFi AI Port',      ['UniFi AI', 'UniFi']),
    (r'unifi[\-_ ]?ap|uap',              'network',    'UniFi AP',           ['UniFi AP', 'UniFi U6']),
    (r'udm|unifi[\-_ ]?dream',           'network',    'UniFi Dream Machine',['UniFi Dream Machine']),
    (r'unifi|ubnt',                       'network',    'UniFi',              ['UniFi']),
    (r'mikrotik',                         'network',    'MikroTik',           ['MikroTik']),
    (r'diskstation|synology',             'nas',        'Synology NAS',       ['Synology']),
    (r'qnap',                             'nas',        'QNAP NAS',          ['QNAP']),
    (r'raspberry|rpi',                    'sbc',        'Raspberry Pi',       ['Raspberry Pi']),
    (r'printer|laserjet|deskjet',         'printer',    'Printer',            ['Printer']),
    (r'camera|ipcam',                     'camera',     'IP Camera',          ['IP Camera']),
    (r'proxmox',                          'server',     'Proxmox',            ['Server']),
    (r'server|srv\b',                     'server',     'Server',             ['Server']),
    (r'galaxy|samsung[\-_ ]?[sa]\d',     'phone',      'Samsung Galaxy',     ['Samsung Galaxy']),
    (r'pixel',                            'phone',      'Google Pixel',       ['Google Pixel']),
    (r'thinkpad',                         'laptop',     'Lenovo ThinkPad',    ['Lenovo ThinkPad']),
    (r'surface',                          'laptop',     'Microsoft Surface',  ['Microsoft Surface']),
]

VENDOR_RULES = [
    (r'^apple',               'phone',      'Apple Device',     ['Apple iPhone']),
    (r'samsung.*electr',      'phone',      'Samsung',          ['Samsung Galaxy']),
    (r'^samsung',             'phone',      'Samsung',          ['Samsung Galaxy']),
    (r'huawei',               'phone',      'Huawei',           ['Huawei']),
    (r'xiaomi',               'phone',      'Xiaomi',           ['Xiaomi']),
    (r'^google',              'phone',      'Google Device',    ['Google Pixel']),
    (r'^dell\b',              'laptop',     'Dell',             ['Dell']),
    (r'lenovo',               'laptop',     'Lenovo',           ['Lenovo']),
    (r'hewlett|^hp\b',        'laptop',     'HP',               ['HP']),
    (r'^asus',                'laptop',     'ASUS',             ['ASUS']),
    (r'espressif',            'plug',       'ESP Device',       ['ESP']),
    (r'^shelly',              'plug',       'Shelly',           ['Shelly']),
    (r'^ikea\b',              'hub',        'IKEA Smart Home',  ['IKEA']),
    (r'signify|philips.*hue', 'hub',        'Philips Hue',      ['Philips Hue']),
    (r'^netatmo',             'sensor',     'Netatmo',          ['Netatmo']),
    (r'^athom',               'hub',        'Athom Homey',      ['Homey Athom']),
    (r'^dyson',               'appliance',  'Dyson',            ['Dyson']),
    (r'ubiquiti|^ui\b',       'network',    'UniFi',            ['UniFi']),
    (r'^cisco',               'network',    'Cisco',            ['Cisco']),
    (r'^netgear',             'network',    'NETGEAR',          ['NETGEAR']),
    (r'^tp[\-_ ]?link',       'network',    'TP-Link',          ['TP-Link']),
    (r'synology',             'nas',        'Synology NAS',     ['Synology']),
    (r'^brother',             'printer',    'Brother',          ['Brother Printer']),
    (r'^canon\b',             'printer',    'Canon',            ['Canon Printer']),
    (r'^epson',               'printer',    'Epson',            ['Epson Printer']),
    (r'hikvision',            'camera',     'Hikvision',        ['Hikvision']),
    (r'raspberry',            'sbc',        'Raspberry Pi',     ['Raspberry Pi']),
    (r'playstation|^sie\b',   'gaming',     'PlayStation',      ['Sony PlayStation']),
    (r'^sonos',               'speaker',    'Sonos',            ['Sonos']),
    (r'^ring\b',              'camera',     'Ring',             ['Ring']),
    (r'nest\b',               'thermostat', 'Google Nest',      ['Nest']),
    (r'ecobee',               'thermostat', 'ecobee',           ['Ecobee']),
    (r'roomba|irobot',        'appliance',  'iRobot Roomba',    ['iRobot Roomba']),
    (r'roborock',             'appliance',  'Roborock',         ['Roborock']),
]

VM_PREFIXES = ['005056','000c29','001c42','080027','525400','00163e','00155d']


# ═══════════════════════════════════════════════════════
# Fingerprint DB + icon file index
# ═══════════════════════════════════════════════════════

_fp_db = None
_icon_index = None


def load_fp_db():
    global _fp_db
    if _fp_db is not None:
        return _fp_db
    _fp_db = {}
    if os.path.exists(FP_DB_FILE):
        try:
            with open(FP_DB_FILE, 'r') as f:
                _fp_db = json.load(f)
        except:
            pass
    return _fp_db


def build_icon_index():
    """Build a dict of {id: filename} from PNG files in icon dir."""
    global _icon_index
    if _icon_index is not None:
        return _icon_index
    _icon_index = {}
    if os.path.isdir(ICON_DIR):
        for fname in os.listdir(ICON_DIR):
            if fname.endswith('_257x257.png'):
                # Extract ID from filename like "299_Apple_HomePod_257x257.png"
                parts = fname.split('_', 1)
                if parts[0].isdigit():
                    _icon_index[parts[0]] = fname
    return _icon_index


def find_fp_icon(search_terms):
    """Search fingerprint DB for best matching icon that exists locally."""
    if not search_terms:
        return None, None
    db = load_fp_db()
    idx = build_icon_index()
    if not db or not idx:
        return None, None

    for term in search_terms:
        tl = term.lower()
        best_id = None
        best_name = None
        best_score = 0
        for fp_id, fp_name in db.items():
            if fp_id not in idx:
                continue  # skip if we don't have the image file
            fl = fp_name.lower()
            if tl in fl:
                score = 100 - min(len(fp_name), 99)
                if fl.startswith(tl):
                    score += 50
                if fl == tl:
                    score += 100
                if score > best_score:
                    best_score = score
                    best_id = fp_id
                    best_name = fp_name
        if best_id:
            return best_id, best_name
    return None, None


def get_icon_url(icon_id):
    """Get web URL for a fingerprint icon by ID."""
    idx = build_icon_index()
    if icon_id in idx:
        return '/clientoverview/icons/' + idx[icon_id]
    return None


# ═══════════════════════════════════════════════════════
# OUI
# ═══════════════════════════════════════════════════════

def load_oui():
    db = {}
    if os.path.exists(OUI_JSON):
        try:
            with open(OUI_JSON, 'r') as f:
                raw = json.load(f)
            for k, v in raw.items():
                if isinstance(v, str):
                    db[k.upper().replace(':','').replace('-','')[:6]] = v
            if db: return db
        except: pass
    if os.path.exists(OUI_NMAP):
        try:
            with open(OUI_NMAP, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#'):
                        parts = line.split(' ', 1)
                        if len(parts) == 2:
                            db[parts[0].upper()[:6]] = parts[1].strip()
            if db: return db
        except: pass
    return db


def load_vendor_cache():
    if os.path.exists(VENDOR_CACHE):
        try:
            with open(VENDOR_CACHE, 'r') as f: return json.load(f)
        except: pass
    return {}

def save_vendor_cache(c):
    try:
        tmp = VENDOR_CACHE + '.tmp'
        with open(tmp, 'w') as f: json.dump(c, f)
        os.replace(tmp, VENDOR_CACHE)
    except: pass

def get_vendor(mac, oui_db, vcache):
    if not mac: return ''
    prefix = mac.upper().replace(':','').replace('-','')[:6]
    v = oui_db.get(prefix, '')
    if v: return v
    v = vcache.get(prefix, '')
    if v: return v
    try:
        import urllib.request
        req = urllib.request.Request('https://api.macvendors.com/' + mac,
            headers={'User-Agent': 'OPNsense-ClientOverview/5.0'})
        resp = urllib.request.urlopen(req, timeout=3)
        vendor = resp.read().decode('utf-8', errors='ignore').strip()
        if vendor and 'not found' not in vendor.lower():
            vcache[prefix] = vendor
            return vendor
    except: pass
    return ''


# ═══════════════════════════════════════════════════════
# Classification
# ═══════════════════════════════════════════════════════

def classify(vendor, mac, hostname=''):
    mac_clean = (mac or '').upper().replace(':','').replace('-','')[:6]
    hn = (hostname or '').lower()
    vl = (vendor or '').lower()
    if mac_clean.lower() in [p.lower() for p in VM_PREFIXES]:
        return ('virtual', 'Virtual Machine', [])
    if hn:
        for pattern, dtype, product, fp_terms in HOSTNAME_RULES:
            m = re.search(pattern, hn)
            if m:
                resolved = []
                for t in fp_terms:
                    try: resolved.append(t.format(*m.groups()) if m.groups() else t)
                    except: resolved.append(t)
                return (dtype, product, resolved)
    if vl:
        for pattern, dtype, product, fp_terms in VENDOR_RULES:
            if re.search(pattern, vl, re.IGNORECASE):
                return (dtype, product, fp_terms)
    return ('unknown', '', [])


# ═══════════════════════════════════════════════════════
# Data sources
# ═══════════════════════════════════════════════════════

def get_arp():
    e = {}
    try:
        out = subprocess.check_output(['/usr/sbin/arp', '-an'], text=True, timeout=10)
        for line in out.strip().split('\n'):
            m = re.search(r'\(([0-9.]+)\)\s+at\s+([0-9a-f:]+)', line, re.I)
            if m:
                ip, mac = m.group(1), m.group(2).lower()
                if mac not in ('(incomplete)', 'ff:ff:ff:ff:ff:ff'):
                    e[ip] = mac
    except: pass
    return e

def read_kea():
    for path in [KEA_LEASE4_FILE, KEA_LEASE4_FILE_ALT]:
        if not os.path.exists(path): continue
        leases = []
        try:
            with open(path, 'r') as f:
                rdr = csv.reader(f)
                hdr = None
                for row in rdr:
                    if not row or row[0].startswith('#'): continue
                    if hdr is None: hdr = [h.strip() for h in row]; continue
                    if len(row) >= len(hdr): leases.append(dict(zip(hdr, row)))
        except: pass
        return leases
    return []

def get_reservations():
    res = {}
    cf = '/usr/local/etc/kea/kea-dhcp4.conf'
    if os.path.exists(cf):
        try:
            with open(cf, 'r') as f: cfg = json.load(f)
            for sn in cfg.get('Dhcp4', {}).get('subnet4', []):
                for r in sn.get('reservations', []):
                    mac = r.get('hw-address', '').lower()
                    if mac: res[mac] = {'hostname': r.get('hostname', ''), 'ip': r.get('ip-address', '')}
        except: pass
    return res

def get_subnets():
    """Build a list of subnets with VLAN IDs from Kea config."""
    subnets = []
    cf = '/usr/local/etc/kea/kea-dhcp4.conf'
    if os.path.exists(cf):
        try:
            with open(cf, 'r') as f: cfg = json.load(f)
            for sn in cfg.get('Dhcp4', {}).get('subnet4', []):
                prefix = sn.get('subnet', '')
                desc = sn.get('description', '')
                if prefix:
                    try:
                        net = ipaddress.ip_network(prefix, strict=False)
                        # Use 3rd octet as VLAN ID
                        parts = str(net.network_address).split('.')
                        vlan_id = parts[2] if len(parts) >= 4 else ''
                        subnets.append({
                            'net': net,
                            'vlan': vlan_id,
                            'name': desc.upper() if desc else '',
                            'prefix': prefix,
                        })
                    except: pass
        except: pass
    return subnets

def ip_to_vlan(ip, subnets):
    """Find which VLAN/subnet an IP belongs to."""
    try:
        addr = ipaddress.ip_address(ip)
        for s in subnets:
            if addr in s['net']:
                return s['vlan']
    except: pass
    return ''

def get_vlan_names(subnets):
    """Return a dict of vlan_id -> name from subnet descriptions."""
    names = {}
    for s in subnets:
        if s['vlan'] and s['name']:
            names[s['vlan']] = s['name']
    return names


# ═══════════════════════════════════════════════════════
# Commands
# ═══════════════════════════════════════════════════════

def cmd_list():
    """List all clients with device info and fingerprint icons."""
    oui = load_oui()
    vcache = load_vendor_cache()
    arp = get_arp()
    reservations = get_reservations()
    subnets = get_subnets()
    leases = read_kea()
    clients = {}
    cache_dirty = False

    for l in leases:
        ip = l.get('address', '')
        mac = l.get('hwaddr', '').lower()
        hn = l.get('hostname', '')
        if not ip or not mac: continue
        try:
            exp = int(l.get('expire', '0'))
            st = int(l.get('state', '0'))
        except: exp, st = 0, 0
        if st == 2: continue
        ri = reservations.get(mac, {})
        if not hn and ri.get('hostname'): hn = ri['hostname']
        old_len = len(vcache)
        vendor = get_vendor(mac, oui, vcache)
        if len(vcache) > old_len: cache_dirty = True
        dtype, product, fp_terms = classify(vendor, mac, hn)
        icon_id, fp_name = find_fp_icon(fp_terms)
        fp_icon = get_icon_url(icon_id) if icon_id else None
        if fp_name and not product: product = fp_name
        online = ip in arp
        lt = 'static' if mac in reservations else 'dynamic'
        if mac not in clients or exp > clients[mac].get('_e', 0):
            clients[mac] = {
                'ip': ip, 'mac': mac, 'hostname': hn, 'vendor': vendor,
                'device_type': dtype, 'product': product,
                'lease_type': lt, 'online': online,
                'fp_icon': fp_icon, '_e': exp,
                'vlan': ip_to_vlan(ip, subnets),
            }

    for ip, mac in arp.items():
        if mac not in clients:
            old_len = len(vcache)
            vendor = get_vendor(mac, oui, vcache)
            if len(vcache) > old_len: cache_dirty = True
            ri = reservations.get(mac, {})
            hn = ri.get('hostname', '')
            dtype, product, fp_terms = classify(vendor, mac, hn)
            icon_id, fp_name = find_fp_icon(fp_terms)
            fp_icon = get_icon_url(icon_id) if icon_id else None
            if fp_name and not product: product = fp_name
            lt = 'static' if mac in reservations else 'arp'
            clients[mac] = {
                'ip': ip, 'mac': mac, 'hostname': hn,
                'vendor': vendor, 'device_type': dtype, 'product': product,
                'lease_type': lt, 'online': True, 'fp_icon': fp_icon, '_e': 0,
                'vlan': ip_to_vlan(ip, subnets),
            }

    if cache_dirty: save_vendor_cache(vcache)

    # ── Known devices persistence ──
    # Load previously known devices
    known = {}
    if os.path.exists(KNOWN_DEVICES_FILE):
        try:
            with open(KNOWN_DEVICES_FILE, 'r') as f:
                known = json.load(f)
        except: pass

    now = time.time()

    # Update known with all current clients
    for mac, c in clients.items():
        known[mac] = {
            'ip': c['ip'], 'mac': mac,
            'hostname': c.get('hostname', ''),
            'vendor': c.get('vendor', ''),
            'device_type': c.get('device_type', 'unknown'),
            'product': c.get('product', ''),
            'lease_type': c.get('lease_type', 'arp'),
            'fp_icon': c.get('fp_icon', None),
            'last_seen': now,
            'first_seen': known.get(mac, {}).get('first_seen', now),
        }

    # Add back offline devices from known list that aren't currently visible
    for mac, kd in known.items():
        if mac not in clients:
            # Only keep devices seen in the last 30 days
            if now - kd.get('last_seen', 0) > 30 * 86400:
                continue
            vendor = kd.get('vendor', '')
            dtype = kd.get('device_type', 'unknown')
            product = kd.get('product', '')
            fp_icon = kd.get('fp_icon', None)
            clients[mac] = {
                'ip': kd.get('ip', ''),
                'mac': mac,
                'hostname': kd.get('hostname', ''),
                'vendor': vendor,
                'device_type': dtype,
                'product': product,
                'lease_type': kd.get('lease_type', 'arp'),
                'online': False,
                'fp_icon': fp_icon,
                '_e': 0,
                'vlan': ip_to_vlan(kd.get('ip', ''), subnets),
            }

    # Save known devices (atomic write to prevent corruption)
    try:
        tmp = KNOWN_DEVICES_FILE + '.tmp'
        with open(tmp, 'w') as f:
            json.dump(known, f)
        os.replace(tmp, KNOWN_DEVICES_FILE)
    except: pass

    out = []
    for mac, c in sorted(clients.items(), key=lambda x: x[1].get('ip', '')):
        c.pop('_e', None)
        # Add first/last seen from known
        if mac in known:
            c['last_seen'] = known[mac].get('last_seen', 0)
            c['first_seen'] = known[mac].get('first_seen', 0)
        out.append(c)

    # Include VLAN name mapping from Kea descriptions
    vnames = get_vlan_names(subnets)
    print(json.dumps({'clients': out, 'vlan_names': vnames}))


def cmd_icons():
    """List all available fingerprint icons (for icon browser)."""
    db = load_fp_db()
    idx = build_icon_index()
    result = []
    for fp_id, fp_name in sorted(db.items(), key=lambda x: x[1].lower()):
        if fp_id in idx:
            result.append({
                'id': fp_id,
                'name': fp_name,
                'url': '/clientoverview/icons/' + idx[fp_id]
            })
    print(json.dumps(result))


def cmd_wol():
    """Send Wake-on-LAN magic packet."""
    if len(sys.argv) < 3:
        print(json.dumps({'status': 'error', 'message': 'MAC address required'}))
        return
    mac = sys.argv[2].strip().lower()
    # Validate MAC format
    if not re.match(r'^([0-9a-f]{2}:){5}[0-9a-f]{2}$', mac):
        print(json.dumps({'status': 'error', 'message': 'Invalid MAC format'}))
        return
    import socket
    mac_bytes = bytes.fromhex(mac.replace(':', ''))
    magic = b'\xff' * 6 + mac_bytes * 16
    # Try sending on all broadcast addresses from Kea subnets
    sent = False
    try:
        subnets = get_subnets()
        targets = set(['255.255.255.255'])
        for s in subnets:
            try:
                net = s['net']
                targets.add(str(net.broadcast_address))
            except: pass
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        for addr in targets:
            try:
                sock.sendto(magic, (addr, 9))
                sent = True
            except: pass
        sock.close()
    except Exception as e:
        print(json.dumps({'status': 'error', 'message': str(e)}))
        return
    if sent:
        print(json.dumps({'status': 'ok', 'message': 'Magic packet sent to ' + mac}))
    else:
        print(json.dumps({'status': 'error', 'message': 'Failed to send packet'}))


if __name__ == '__main__':
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == 'icons':
            cmd_icons()
        elif cmd == 'wol':
            cmd_wol()
        else:
            cmd_list()
    else:
        cmd_list()
