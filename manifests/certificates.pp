# Class: node_encrypt::certificates
#
# This class distributes public certificates from your CA node to all compile
# masters in a Master of Masters configuration. You should classify all your
# master nodes with this class, including the CA.
#
# It will set up a file mountpoint on the CA node, and then sync all agent public
# certificates to the $ssldir/certs directory on each compile master, where they
# can be used to encrypt secrets for agents.
#
# **Note**:
# If this is applied to nodes in a flat hierarchy (i.e., non Master of Masters),
# then all agents will have all public certificates synched. This is not a
# security risk, as public certificates are designed to be shared widely, but it
# is something you should be aware of.
#
# Parameters:
#
# [*whitelist*]
# This is a comma-separated list of all nodes who are authorized to synchronize
# *all* certificates from the CA node. Defaults to `*`, or all nodes.
#
class node_encrypt::certificates (
  $whitelist = '*',
) {

  # Matches when the agent node is the CA itself.
  # Set up file mounts
  if $::fqdn == $::settings::ca_server {
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
  # Compiled on the CA, meaning that the agent is a compile master client of the CA
  # Synch all agent certificates so we can encrypt for them
  elsif $servername == $::settings::ca_server {
    file { "${::settings::ssldir}/certs":
      ensure  => directory,
      recurse => true,
      ignore  => 'pe-internal-*',
      source  => "puppet://${::settings::ca_server}/public_certificates/", # lint:ignore:puppet_url_without_modules
    }
  }
  # Otherwise, we're just an agent node.
  else {
    # noop
  }
}
