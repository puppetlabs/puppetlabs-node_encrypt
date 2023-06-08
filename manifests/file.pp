# Notice:
# This defined type is deprecated and only used for backward code compatibility.
# This uses the modern deferred function under the hood and will be removed in
# the next major release. That means that this module now REQUIRES Puppet 6.x+.
#
# Parameters:
# [*ensure*]
#   Specifies the desired state of the file. Valid values are 'absent', 'present', or 'file'.
#
# [*path*]
#   The path to the file.
#
# [*backup*]
#   (Optional) Whether to create backups of the file when it changes.
#
# [*checksum*]
#   (Optional) The checksum type to use for file content validation.
#
# [*content*]
#   (Optional) The content of the file. This will be encrypted with node_encrypt() and passed to
#   an instance of the node_encrypted_file type, which will provide the content to the file.
#
# [*encrypted_content*]
#   (Optional) The encrypted content of the file. If specified, it will be decrypted and used as
#   the content of the file.
#
# [*force*]
#   (Optional) Whether to force file updates even if the file is managed by another system.
#
# [*group*]
#   (Optional) The group ownership of the file.
#
# [*owner*]
#   (Optional) The owner of the file.
#
# [*mode*]
#   (Optional) The file mode or permission settings.
#
# [*replace*]
#   (Optional) Whether to replace the file if it already exists.
#
# [*selinux_ignore_defaults*]
#   (Optional) Whether to ignore SELinux defaults when managing the file.
#
# [*selrange*]
#   (Optional) The SELinux range for the file.
#
# [*selrole*]
#   (Optional) The SELinux role for the file.
#
# [*seltype*]
#   (Optional) The SELinux type for the file.
#
# [*seluser*]
#   (Optional) The SELinux user for the file.
#
define node_encrypt::file (
  Enum['absent', 'present', 'file'] $ensure                  = 'file',
  String[1]                         $path                    = $title,
  Optional[Boolean]                 $backup                  = undef,
  Optional[String[1]]               $checksum                = undef,
  Optional[String[1]]               $content                 = undef,
  Optional[String[1]]               $encrypted_content       = undef,
  Optional[Boolean]                 $force                   = undef,
  Optional[String[1]]               $group                   = undef,
  Optional[String[1]]               $owner                   = undef,
  Optional[Stdlib::Filemode]        $mode                    = undef,
  Optional[Boolean]                 $replace                 = undef,
  Optional[Boolean]                 $selinux_ignore_defaults = undef,
  Optional[String[1]]               $selrange                = undef,
  Optional[String[1]]               $selrole                 = undef,
  Optional[String[1]]               $seltype                 = undef,
  Optional[String[1]]               $seluser                 = undef,
) {
  warning('This defined type is deprecated and will be removed in the next major release. Use the node_encrypt::secret function instead.')
  notify { 'This defined type is deprecated and will be removed in the next major release.Use the node_encrypt::secret function instead.': }

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
