define hostapd::bssid(
  $ssid,
  $bss            = $name,
  $bssid          = undef,
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
) {
  Class['hostapd::install'] ->
  Hostapd::Bssid[$title] ~>
  Class['hostapd::service']

  concat::fragment { "hostapd_bss_${bss}":
    target  => 'hostapd.conf',
    content => template('hostapd/bssid.erb', 'hostapd/hostapd.conf.erb'),
    order   => "02_${bss}",
  }
}
