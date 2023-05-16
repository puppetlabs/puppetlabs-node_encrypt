$encrypted = lookup('encrypted_foo')
file { '/etc/something/or/other.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  content => Deferred('node_decrypt', [$encrypted]),
}
