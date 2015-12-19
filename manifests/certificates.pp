# Class: node_encrypt::certificates
#
# This class distributes public certificates from your CA node to all compile
# masters. You should classify all your masters with this class.
#
# It will set up a file mountpoint on the CA node, and then sync all agent public
# certificates to the $ssldir/certs directory on each compile master, where they
# can be used to encrypt secrets for agents.
#
# Parameters:
#
# [*ca_node*]
# If the CA autodetection doesn't work for you, then you should put the certname
# of your CA here.
#
# [*whitelist*]
# This is a comma-separated list of all nodes who are authorized to syncronize
# certificates from the CA node. Defaults to `*`, or all nodes.
#
class node_encrypt::certificates (
  $ca_node   = undef,
  $whitelist = '*',
) {

  if ($ca_node and $ca_node == $::clientcert) or (! $ca_node and $::is_ca_node) {
    ini_setting { 'public certificates mountpoint path':
      ensure            => present,
      path              => "${::settings::confdir}/fileserver.conf",
      section           => 'public_certificates',
      setting           => 'path',
      key_val_separator => ' ',
      value             => "${::settings::ssldir}/ca/signed/",
    }

    ini_setting { 'public certificates mountpoint whitelist':
      ensure            => present,
      path              => "${::settings::confdir}/fileserver.conf",
      section           => 'public_certificates',
      setting           => 'allow',
      key_val_separator => ' ',
      value             => $whitelist,
    }

  }
  else {
    file { "${::settings::ssldir}/certs":
      ensure  => directory,
      recurse => true,
      ignore  => 'pe-internal-*',
      source  => 'puppet:///public_certificates/',
    }
  }
}
