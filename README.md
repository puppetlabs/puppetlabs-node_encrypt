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
    * This is a Puppet Face that generates encrypted on the command line.
    * `puppet node encrypt -t testhost.example.com "encrypt some text"`
* `node_encrypt()`
    * This is a Puppet function used to programmatically generate encrypted text.
      It's used internally so you won't need to call it yourself when using the
      `node_encrypt::file` type.
    * This can be used to generate text to pass to other types if/when they add
      support for this module.
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
is encrypted specifically for each node. You cannot share secrets amongst nodes.

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

The `node_encrypt::certificates` class can synchronize certificates across your
infrastructure so that encryption works from all compile masters. Please be aware
that **this class will create a filesystem mount on the CA node!**

Classify all your masters, including the CA or Master of Masters, with this class.
This will ensure that all masters have all agents' public certificates. You can
limit access to the certificates by passing a comma-separated list of nodes as
the `$whitelist` parameter.

## Ecosystem

#### What about [Hiera eyaml](https://github.com/TomPoulton/hiera-eyaml)?

Does this project replace that tool?

Not at all. They exist in different problem spaces.  Hiera eyaml is intended to
protect your secrets on-disk and in your repository.  With Hiera eyaml, you can
add secrets to your codebase without having to secure the entire codebase.
Having access to the code doesn't mean having access to the secrets in that code.

But the secrets are still exposed in the catalog and in reports. This means you
should be protecting them instead. `node_encrypt` addresses that problem. The two
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

