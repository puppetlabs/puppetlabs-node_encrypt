# Definition: node_encrypt::file
#
# This definition allows you to declare node_encrypt managed files.
#
# Notice:
# This defined type is deprecated and only used for backward code compatibility.
# This uses the modern deferred function under the hood and will be removed in
# the next major release. That means that this module now REQUIRED Puppet 6.x+.
#
# Parameters:
# All parameters are as for the file type. The value of $content will
# be encrypted with node_encrypt() and passed to an instance of the
# node_encrypted_file type, which will provide the content to the file.
#
# Sample Usage:
#  node_encrypt::file { '/etc/my.cnf':
#    owner   => 'root',
#    group   => 'root,
#    content => file('mymod/my.cnf'),
#  }
#
define node_encrypt::file (
  $ensure                  = 'file',
  $path                    = $title,
  $backup                  = undef,
  $checksum                = undef,
  $content                 = undef,
  $encrypted_content       = undef,
  $force                   = undef,
  $group                   = undef,
  $owner                   = undef,
  $mode                    = undef,
  $replace                 = undef,
  $selinux_ignore_defaults = undef,
  $selrange                = undef,
  $selrole                 = undef,
  $seltype                 = undef,
  $seluser                 = undef,
) {
  warning('This defined type is now deprecated and will be removed in the next major release. Use the node_encrypt::secret function instead.')
  notify { 'Warning: this defined type is now deprecated and will be removed in the next major release. Use the node_encrypt::secret function instead.': }

  unless $ensure in ['absent', 'present', 'file'] {
    fail("Node_encrypt::File[${title}] invalid value for ensure")
  }

  if $content and $encrypted_content {
    fail("Node_encrypt::File[${title}] pass only one of content and encrypted_content")
  }

  if $ensure == 'absent' {
    $real_content = undef
  }
  else {
    $real_content = $content ? {
      undef   => Deferred('node_decrypt', [$encrypted_content]),
      default => $content.node_encrypt::secret,
    }
  }

  file { $title:
    ensure                  => $ensure,
    path                    => $path,
    backup                  => $backup,
    checksum                => $checksum,
    content                 => $real_content,
    force                   => $force,
    group                   => $group,
    mode                    => $mode,
    owner                   => $owner,
    replace                 => $replace,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    selrange                => $selrange,
    selrole                 => $selrole,
    seltype                 => $seltype,
    seluser                 => $seluser,
  }
}
