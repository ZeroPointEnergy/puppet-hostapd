class hostapd (
  $ssid,
  $interface      = undef,
  $bridge         = undef,
  $driver         = undef,
  $hw_mode        = undef,
  $channel        = undef,
  $wmm_enabled    = undef,
  $ieee80211n     = undef,
  $ht_capab       = undef,
  $auth_algs      = undef,
  $wpa            = undef,
  $wpa_passphrase = undef,
  $wpa_key_mgmt   = undef,
  $wpa_pairwise   = undef,
  $rsn_pairwise   = undef,
  $version        = present,
  $enable         = true,
  $start          = true,
  $bssids         = {},
) {
  class{'hostapd::install':} -> Class['hostapd']
  Class['hostapd'] ~> class{'hostapd::service':}

  concat {'hostapd.conf': 
    path   => '/etc/hostapd/hostapd.conf',
    owner  => root,
    group  => root,
    mode   => '0600',
  }

  concat::fragment {'hostapd.conf':
    target  => 'hostapd.conf',
    content => template('hostapd/hostapd.conf.erb'),
    order   => '01',
  }

  validate_hash($::hostapd::bssids)
  create_resources(hostapd::bssid, $::hostapd::bssids)

  shellvar { 'DAEMON_CONF':
    ensure => present,
    target => '/etc/default/hostapd',
    value  => '/etc/hostapd/hostapd.conf',
  }

}
