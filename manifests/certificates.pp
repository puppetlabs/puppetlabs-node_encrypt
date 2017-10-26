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
# *all* certificates from the CA node. Defaults to `*`, or all nodes. Set to
# `false` to disable whitelist management.
#
# [*manage_hocon*]
#  Set to `true` if you've disabled legacy `auth.conf` and are on Puppet 5.
#
# [*sort_order*]
# If you've customized your HOCON-based `auth.conf`, set the appropriate sort
# order here. The default rule's weight is 500, so this parameter defaults to
# `300` so it overrides the default.

class node_encrypt::certificates (
  $whitelist    = '*',
  $manage_hocon = false,
  $sort_order   = 300,
) {

  # Matches when the agent node is the CA itself.
  if $::fqdn == $::settings::ca_server {

    # Set up file mountpoint to distribute the certs
    ini_setting { 'public certificates mountpoint path':
      ensure            => present,
      path              => $::settings::fileserverconfig,
      section           => 'public_certificates',
      setting           => 'path',
      key_val_separator => ' ',
      value             => "${::settings::ssldir}/ca/signed/",
    }

    # Puppet 5 hard deprecated managing authentication in fileserver.conf
    # which is too bad, because that was the only way to reliably associate a
    # rule with a mount in an automated fashion.
    if versioncmp($::puppetversion, '5.0.0') < 0 {
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
      # if we're on PE, we can assume a relatively modern & managed auth.conf
      if defined('$::pe_server_version') {
        pe_puppet_authorization::rule { 'public certificates mountpoint whitelist':
          match_request_path   => '^/puppet/v3/file_(metadata|content)s?/public_certificates',
          match_request_type   => 'regex',
          match_request_method => 'get',
          allow                => split($whitelist, ','),
          sort_order           => 300,
          path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
        }
      }
      else {
        # We can't actually do this automatically because we have no way of knowing
        # whether the machine is configured with legacy auth.conf or HOCON.
        if $manage_hocon {
          puppet_authorization::rule { 'public certificates mountpoint whitelist':
            match_request_path   => '^/puppet/v3/file_(metadata|content)s?/public_certificates',
            match_request_type   => 'regex',
            match_request_method => 'get',
            allow                => split($whitelist, ','),
            sort_order           => $sort_order,
            path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
          }
        }
        elsif $whitelist {
          # If the user has specified a whitelist, but haven't indicated that they're
          # using HOCON, we don't have any option but to fail and ask them to configure
          # manually (and then set the parameters of this class appropriately).
          fail("Node Encrypt: As of Puppet 5, it's no longer possible to reliably manage the whitelist automatically on Open Source Puppet. See https://github.com/binford2k/binford2k-node_encrypt#managing-certificates-on-open-source-puppet-5 for more information on configuring this manually.")
        }
        else {
          # noop
        }
      }
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
