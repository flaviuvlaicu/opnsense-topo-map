<?php

namespace OPNsense\ClientOverview\Api;

use OPNsense\Base\ApiControllerBase;

class ServiceController extends ApiControllerBase
{
    private $iconDir = '/usr/local/opnsense/www/clientoverview/icons/';
    private $customFile = '/usr/local/opnsense/scripts/clientoverview/custom_devices.json';
    private $topoFile = '/usr/local/opnsense/scripts/clientoverview/topology.json';

    public function clientsAction()
    {
        $result = ['status' => 'ok', 'clients' => [], 'vlan_names' => new \stdClass()];
        $backend = new \OPNsense\Core\Backend();
        $response = $backend->configdRun('clientoverview list');

        if (!empty($response)) {
            $data = json_decode(trim($response), true);
            if (is_array($data)) {
                // New format: {clients: [...], vlan_names: {...}}
                $clients = isset($data['clients']) ? $data['clients'] : $data;
                $vnames = isset($data['vlan_names']) ? $data['vlan_names'] : [];

                $customs = $this->loadCustom();
                foreach ($clients as &$client) {
                    $mac = strtolower($client['mac'] ?? '');
                    if (isset($customs[$mac])) {
                        if (!empty($customs[$mac]['name'])) {
                            $client['custom_name'] = $customs[$mac]['name'];
                        }
                        if (!empty($customs[$mac]['icon'])) {
                            $client['custom_icon'] = '/clientoverview/icons/' . $customs[$mac]['icon'];
                        }
                        if (!empty($customs[$mac]['fp_icon'])) {
                            $client['fp_icon'] = $customs[$mac]['fp_icon'];
                        }
                        if (!empty($customs[$mac]['device_type'])) {
                            $client['device_type'] = $customs[$mac]['device_type'];
                        }
                    }
                }
                $result['clients'] = $clients;
                $result['vlan_names'] = !empty($vnames) ? $vnames : new \stdClass();
            }
        }
        return $result;
    }

    /**
     * List all available fingerprint icons for the icon browser.
     */
    public function iconsAction()
    {
        $result = ['status' => 'ok', 'icons' => []];
        $backend = new \OPNsense\Core\Backend();
        $response = $backend->configdRun('clientoverview icons');

        if (!empty($response)) {
            $data = json_decode(trim($response), true);
            if (is_array($data)) {
                $result['icons'] = $data;
            }
        }
        return $result;
    }

    public function setDeviceAction()
    {
        $result = ['status' => 'error'];
        if ($this->request->isPost()) {
            $mac = strtolower(trim($this->request->getPost('mac', 'string', '')));
            $name = trim($this->request->getPost('name', 'string', ''));
            $deviceType = trim($this->request->getPost('device_type', 'string', ''));
            $fpIcon = trim($this->request->getPost('fp_icon', 'string', ''));

            if (!empty($mac)) {
                $customs = $this->loadCustom();
                if (!isset($customs[$mac])) $customs[$mac] = [];
                // Name handling: empty string clears alias
                if ($name !== '') {
                    $customs[$mac]['name'] = $name;
                } else {
                    // Check if name was explicitly sent (even empty) via raw POST
                    $rawPost = $this->request->getPost();
                    if (is_array($rawPost) && array_key_exists('name', $rawPost)) {
                        unset($customs[$mac]['name']);
                    }
                }
                if ($deviceType !== '') $customs[$mac]['device_type'] = $deviceType;
                if ($fpIcon !== '') {
                    $customs[$mac]['fp_icon'] = $fpIcon;
                    // Clear custom upload if setting fingerprint icon
                    unset($customs[$mac]['icon']);
                }
                $this->saveCustom($customs);
                $result = ['status' => 'ok'];
            }
        }
        return $result;
    }

    /**
     * Clear custom/fingerprint icon for a device (revert to auto-detect).
     */
    public function clearIconAction()
    {
        $result = ['status' => 'error'];
        if ($this->request->isPost()) {
            $mac = strtolower(trim($this->request->getPost('mac', 'string', '')));
            if (!empty($mac)) {
                $customs = $this->loadCustom();
                if (isset($customs[$mac])) {
                    if (!empty($customs[$mac]['icon'])) {
                        @unlink($this->iconDir . $customs[$mac]['icon']);
                    }
                    unset($customs[$mac]['icon']);
                    unset($customs[$mac]['fp_icon']);
                    $this->saveCustom($customs);
                }
                $result = ['status' => 'ok'];
            }
        }
        return $result;
    }

    public function uploadIconAction()
    {
        $result = ['status' => 'error'];
        try {
            if (!$this->request->isPost()) {
                $result['message'] = 'POST required';
                return $result;
            }
            if (!$this->request->hasFiles()) {
                $result['message'] = 'No file uploaded';
                return $result;
            }
            $mac = strtolower(trim($this->request->getPost('mac', 'string', '')));
            if (empty($mac)) {
                $result['message'] = 'MAC required';
                return $result;
            }
            $macSafe = preg_replace('/[^a-f0-9]/', '', $mac);

            if (!is_dir($this->iconDir)) {
                @mkdir($this->iconDir, 0755, true);
            }
            if (!is_dir($this->iconDir) || !is_writable($this->iconDir)) {
                $result['message'] = 'Icon directory not writable';
                return $result;
            }

            foreach ($this->request->getUploadedFiles() as $file) {
                $ext = strtolower(pathinfo($file->getName(), PATHINFO_EXTENSION));
                if (!in_array($ext, ['png','svg','jpg','jpeg','webp'])) {
                    $result['message'] = 'Use PNG, SVG, JPG, or WebP';
                    return $result;
                }
                if ($file->getSize() > 2 * 1024 * 1024) {
                    $result['message'] = 'File too large (max 2MB)';
                    return $result;
                }
                $filename = 'custom_' . $macSafe . '.' . $ext;
                $destPath = $this->iconDir . $filename;

                // Try Phalcon moveTo first, fall back to move_uploaded_file
                $moved = false;
                if ($file->moveTo($destPath)) {
                    $moved = true;
                } elseif (is_uploaded_file($file->getTempName())) {
                    $moved = move_uploaded_file($file->getTempName(), $destPath);
                }

                if ($moved) {
                    @chmod($destPath, 0644);
                    $customs = $this->loadCustom();
                    if (!isset($customs[$mac])) $customs[$mac] = [];
                    $customs[$mac]['icon'] = $filename;
                    unset($customs[$mac]['fp_icon']);
                    $this->saveCustom($customs);
                    $result = ['status' => 'ok', 'icon' => '/clientoverview/icons/' . $filename];
                } else {
                    $result['message'] = 'Failed to save file';
                }
            }
        } catch (\Exception $e) {
            $result['message'] = 'Upload error: ' . $e->getMessage();
        }
        return $result;
    }

    /**
     * Load saved topology layout.
     */
    public function topologyAction()
    {
        $result = ['status' => 'ok', 'topology' => ['nodes' => new \stdClass()]];
        if (file_exists($this->topoFile)) {
            $data = json_decode(file_get_contents($this->topoFile), true);
            if (is_array($data)) {
                $result['topology'] = $data;
            }
        }
        return $result;
    }

    /**
     * Save topology layout.
     */
    public function saveTopologyAction()
    {
        $result = ['status' => 'error'];
        if ($this->request->isPost()) {
            // Try POST param first (without sanitizer that strips JSON)
            $json = $this->request->getPost('topology');
            if (empty($json)) {
                // Fallback: try raw body
                $json = $this->request->getRawBody();
            }
            if (!empty($json)) {
                $data = json_decode($json, true);
                if (is_array($data)) {
                    $dir = dirname($this->topoFile);
                    if (!is_dir($dir)) @mkdir($dir, 0755, true);
                    if (file_put_contents($this->topoFile, json_encode($data, JSON_PRETTY_PRINT)) !== false) {
                        $result = ['status' => 'ok'];
                    } else {
                        $result['message'] = 'write failed';
                    }
                } else {
                    $result['message'] = 'invalid json';
                }
            } else {
                $result['message'] = 'no data';
            }
        }
        return $result;
    }

    /**
     * Forget a device — remove from known devices list.
     */
    public function forgetDeviceAction()
    {
        $result = ['status' => 'error'];
        if ($this->request->isPost()) {
            $mac = strtolower(trim($this->request->getPost('mac', 'string', '')));
            if (!empty($mac)) {
                // Remove from known devices
                $knownFile = '/usr/local/opnsense/scripts/clientoverview/known_devices.json';
                if (file_exists($knownFile)) {
                    $known = json_decode(file_get_contents($knownFile), true);
                    if (is_array($known) && isset($known[$mac])) {
                        unset($known[$mac]);
                        file_put_contents($knownFile, json_encode($known, JSON_PRETTY_PRINT));
                    }
                }
                // Also remove from custom devices
                $customs = $this->loadCustom();
                if (isset($customs[$mac])) {
                    unset($customs[$mac]);
                    $this->saveCustom($customs);
                }
                // Also remove from topology
                if (file_exists($this->topoFile)) {
                    $topo = json_decode(file_get_contents($this->topoFile), true);
                    if (is_array($topo) && isset($topo['nodes'][$mac])) {
                        unset($topo['nodes'][$mac]);
                        // Remove children that had this as parent
                        foreach ($topo['nodes'] as $m => &$n) {
                            if (isset($n['parent']) && $n['parent'] === $mac) {
                                $n['parent'] = null;
                                $n['port'] = null;
                            }
                        }
                        file_put_contents($this->topoFile, json_encode($topo, JSON_PRETTY_PRINT));
                    }
                }
                $result = ['status' => 'ok'];
            }
        }
        return $result;
    }

    /**
     * Send Wake-on-LAN magic packet to a device.
     */
    public function wakeDeviceAction()
    {
        $result = ['status' => 'error'];
        if ($this->request->isPost()) {
            $mac = strtolower(trim($this->request->getPost('mac', 'string', '')));
            if (!empty($mac) && preg_match('/^([0-9a-f]{2}:){5}[0-9a-f]{2}$/', $mac)) {
                $backend = new \OPNsense\Core\Backend();
                $response = $backend->configdRun("clientoverview wol {$mac}");
                if (!empty($response)) {
                    $data = json_decode(trim($response), true);
                    if (is_array($data)) {
                        $result = $data;
                    }
                }
            } else {
                $result['message'] = 'Invalid MAC address';
            }
        }
        return $result;
    }

    private function loadCustom() {
        if (file_exists($this->customFile)) {
            $d = json_decode(file_get_contents($this->customFile), true);
            if (is_array($d)) return $d;
        }
        return [];
    }

    private function saveCustom($d) {
        file_put_contents($this->customFile, json_encode($d, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
    }
}
