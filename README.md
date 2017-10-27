# `node_encrypt`: over the wire encryption.

1. [Overview](#overview)
1. [Usage](#usage)
1. [Ecosystem](#ecosystem)

## Overview

Do you wish your Puppet catalogs didn't contain plain text secrets? Are you tired
of limiting access to your Puppet reports because of the passwords clearly
visible in the change events?

This module will encrypt values for each node specifically, using their own
certificates. This means that not only do you not have plain text secrets, but
each node can decrypt only its own secrets.

What precisely does that mean? A resource that looks like this will never have
the contents of the file in the catalog or in any reports.

```Puppet
node_encrypt::file { '/tmp/foo':
  owner   => 'root',
  group   => 'root',
  content => 'This string will never appear in the catalog.',
}
```

This also comes with a Puppet Face which can be used to generate the encrypted
block ready for pasting into your manifest, and a Puppet function which can be
used to programmatically generate the encrypted block.

**Note**: Because it requires access to each node's signed certificates, this is
only useful on the CA node unless you distribute certificates or generate
encrypted blocks on the CA using the `puppet node encrypt` face. There is a class
included to automate the public certificate distribution.

## Usage

* `node_encrypt::file`
    * This is a defined type that wraps a standard file resource, but allows you
      to encrypt the content in the catalog and reports.
* `puppet node encrypt`
    * This is a Puppet Face that generates encrypted ciphertext on the command line.
    * `puppet node encrypt -t testhost.example.com "encrypt some text"`
* `puppet node decrypt`
    * This is a Puppet Face that decrypts ciphertext on the command line. It is
      useful in command-line scripts, or in `exec` statements.
* `node_encrypt()`
    * This is a Puppet function used to programmatically generate encrypted text.
      It's used internally so you won't need to call it yourself when using the
      `node_encrypt::file` type.
    * This can be used to generate text to pass to other types if/when they add
      support for this module.
    * Parameters:
        * String to be encrypted.
* `redact()`
    * This Puppet function allows you to remove from the catalog the value of a
      parameter that a class was called with.
        * The name of the parameter to redact.
        * The message to replace the parameter's value with. (optional)
* `node_encrypt::certificates`
    * This class will synchronize certificates to all compile masters.

The simplest usage is like the example shown in the [Overview](#overview). This
defined type accepts most of the standard file parameters and simply encrypts the
file contents in the catalog.

    # puppet agent -t
    Info: Using configured environment 'production'
    Info: Retrieving pluginfacts
    Info: Retrieving plugin
    Info: Loading facts
    Info: Caching catalog for master.puppetlabs.vm
    Info: Applying configuration version '1450109738'
    Notice: /Stage[main]/Main/Node[default]/Node_encrypt::File[/tmp/foo]/Node_encrypted_file[/tmp/foo]/ensure: created
    Notice: Applied catalog in 9.33 seconds
    # echo blah > /tmp/foo
    # puppet agent -t
    Info: Using configured environment 'production'
    Info: Retrieving pluginfacts
    Info: Retrieving plugin
    Info: Loading facts
    Info: Caching catalog for master.puppetlabs.vm
    Info: Applying configuration version '1450109821'
    Notice: /Stage[main]/Main/Node[default]/Node_encrypt::File[/tmp/foo]/Node_encrypted_file[/tmp/foo]/content: content changed '<<encrypted>>' to '<<encrypted>>'
    Notice: Applied catalog in 7.61 seconds

If you'd like to pre-encrypt your data, you can pass it as the `encrypted_content`
instead. The ciphertext can be stored directly in your manifest file, in Hiera,
or anywhere else you'd like. Note that if you choose to do this, the ciphertext
must be encrypted specifically for each node. You cannot share secrets amongst nodes.

```Puppet
node_encrypt::file { '/tmp/foo':
  owner             => 'root',
  group             => 'root',
  encrypted_content => hiera('encrypted_foo'),
}
```

The ciphertext can be generated on the CA using the `puppet node encrypt` command.

    # puppet node encrypt -t testhost.puppetlabs.vm "encrypt some text"
    -----BEGIN PKCS7-----
    MIIMqwYJKoZIhvcNAQcDoIIMnDCCDJgCAQAxggJ7MIICdwIBADBfMFoxWDBWBgNV
    BAMMT1B1cHBldCBDQSBnZW5lcmF0ZWQgb24gcHVwcGV0ZmFjdG9yeS5wdXBwZXRs
    [...]
    MbxinAGtO0eF4i8ova9MJykDPe600IY2b9ZY4mIskDqvHS9bVoK4fJGuRWAXiVBY
    bFaZ36l90LkyLLrrSfjah/Tdqd8cHrphofsWVFWBmM1uErX1jBuuzngIehm40pN7
    ClVbGy9Ow3zado1spWfDwekLoiU5imk77J9POy0X8w==
    -----END PKCS7-----

### Function usage:

```Puppet
class secret ($password) {
  $encrypted = node_encrypt($password)
  
  file { '/etc/something/or/other.conf:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "password = ${encrypted}",
  }

  redact('password')
  
  # could be called with the optional second parameter
  # redact('password', 'The password has been removed from the catalog')
}
```

#### `node_encrypt($string)`

This function simply encrypts the string passed to it using the certificate
belonging to the client the catalog is being compiled for.

```Puppet
$encrypted = node_encrypt($password)
```

#### `redact($parameter, $replacewith)`

This function will modify the catalog during compilation to remove the named
parameter from the class from which it was called. For example, if you wrote a
class named `foo` and called `redact('bar')` from within that class, then the
catalog would not record the value of `bar` that `foo` was called with.

```Puppet
class foo($bar) {
  # this call will display the proper output, but because it's not a resource
  # the string won't exist in the catalog.
  notice("Class['foo'] was called with param ${bar}")

  # but the catalog won't record what the passed in param was.
  redact('bar')
}

class { 'foo':
  bar => 'this will not appear in the catalog',
}
```

**Warning**: If you use that parameter to declare other classes or resources,
then you must take further action to remove the parameter from those declarations!

This takes an optional second parameter of the value to replace the original
parameter declaration with. This parameter is required if the class declares
a type that is not `String` for the parameter you're redacting.


### Using the command line decryption tool

This comes with a Puppet Face that can decrypt ciphertext on the command line,
using the same agent certs as the encrypted file resource type. You can use this
in your own scripts via several methods. Assume that we've set a variable like such:

    # export SECRET=$(puppet node encrypt -t testhost.puppetlabs.vm "your mother was a hamster")

* Passing data directly using the `--data` option:
    * `puppet node decrypt --data "${SECRET}"`
    * On some platforms, this may exceed command length limits!
* Setting data in an environment variable and passing the name:
    * `puppet node decrypt --env SECRET`
* Piping data to STDIN:
    * `echo "${SECRET}" | puppet node decrypt`
    * `cat /file/with/encrypted/blob.txt | puppet node decrypt`

This can be useful when running `exec resources` with embedded secrets. Note the
careful use of single quotes to prevent variable expansion in Puppet:

```Puppet
exec { 'set service passphrase':
  command     => 'some-service --set-passphrase="$(puppet node decrypt --env SECRET)"',
  path        => '/opt/puppetlabs/bin:/usr/bin',
  environment => "SECRET=${node_encrypt('and your father smelt of elderberries')}",
}
```

### Automatically distributing certificates to compile masters

The `node_encrypt::certificates` class can synchronize certificates across your
infrastructure so that encryption works from all compile masters. Please be aware
that **this class will create a fileserver mount on the CA node** making public
certificates available for download by nodes listed in the `$whitelist`.

Classify all your masters, including the CA or Master of Masters, with this class.
This will ensure that all masters have all agents' public certificates. Limit access
to the certificates by passing a comma-separated list of compile master nodes as
the `$whitelist` parameter.

Parameters:

* [*legacy*]
    * Set to `true` if you're still using legacy `auth.conf` on Puppet 5.

* [*sort_order*]
    * If you've customized your HOCON-based `auth.conf`, set the appropriate sort
      order here. The default rule's weight is 500, so this parameter defaults to
      `300` to ensure that it overrides the default.

* [*whitelist*]
    * This is deprecated and has no effect. It will be removed in the next major release.


**Note**:<br />
If this is applied to nodes in a flat hierarchy (i.e., non Master of Masters),
then all agents will have all public certificates synched. This is not a
security risk, as public certificates are designed to be shared widely, but it
is something you should be aware of.

#### Deprecated Parameters

Since public certificates are designed to be shared widely without a security
risk, we made the decision to simplify and no longer manage a whitelist of
compile masters allowed to access the `public_certificates` mountpoint. If you
would like to enforce a whitelist anyway, then you can use one of the following
methods:

If you're using the legacy `auth.conf` format then you'll need to configure it
manually by editing `$confdir/auth.conf` on the CA server. Ensure that this
stanza comes before the existing `^/puppet/v3/file` rule and set the `whitelist`
parameter to `false` in your classification to disable the error.

```
# Node_encrypt: Allow limited access to the 'public_certificates' mountpoint:
path ~ ^/puppet/v3/file_(metadata|content)s?/public_certificates/
auth yes
allow list,of,whitelisted,certnames
```

If you're using the modern HOCON based `auth.conf` format, then you can manage
access using a Puppet resource such as the following. Ensure that the `sort_order`
is lower than `300`, or the value you passed to `node_encrypt::certificates`.

```Puppet
puppet_authorization::rule { 'public certificates mountpoint override':
  match_request_path   => '^/puppet/v3/file_(metadata|content)s?/public_certificates',
  match_request_type   => 'regex',
  match_request_method => 'get',
  allow                => ['array', 'of', 'whitelisted', 'certnames'],
  sort_order           => 250,
  path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
}
```


### Using on masterless infrastructures

For the most part, `node_encrypt` doesn't have as much value in a masterless
setup. When the agent is compiling its own catalog, there's no cached catalog or
network transfer. Nevertheless, there are use cases for it. For example, if you
have a report server configured, or are submitting catalogs & reports to PuppetDB,
you likely want to keep secrets hidden.

`node_encrypt` won't work out of the box on a masterless node because it relies
on the existence of the CA certificates. But it's easy to generate these
certificates so that it will work. Keep in mind that without the full CA
infrastructure, no other node will be able to decrypt these secrets.

```
$ rm -rf $(puppet master --configprint ssldir)/*
$ puppet cert list -a
$ puppet cert --generate ${puppet master --configprint certname} --dns_alt_names "$(puppet master --configprint dns_alt_names)"
```

## Ecosystem

#### What about [Hiera eyaml](https://github.com/TomPoulton/hiera-eyaml)?

Does this project replace that tool?

Not at all. They exist in different problem spaces.  Hiera eyaml is intended to
protect your secrets on-disk and in your repository.  With Hiera eyaml, you can
add secrets to your codebase without having to secure the entire codebase.
Having access to the code doesn't mean having access to the secrets in that code.

But the secrets are still exposed in the catalog and in reports. This means you
should be protecting them as well. `node_encrypt` addresses that problem. The two
projects happily coexist. You can (and should) use `eyaml` to store your secrets
on disk, while you use `node_encrypt` to protect the rest of the pipeline.

#### Integration with other tools

This was designed to make it easy to integrate support into other tooling. For
example, [this pull request](https://github.com/richardc/puppet-datacat/pull/17/files)
adds transparent encryption support to _rc's popular `datacat` module.

## Disclaimer

I take no liability for the use of this module. As this uses standard Ruby and
OpenSSL libraries, it should work anywhere Puppet itself does. I have not yet
validated on anything other than CentOS, though.

Contact
-------

binford2k@gmail.com

