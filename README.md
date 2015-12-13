# `node_encrypt`: over the wire encryption.

1. [Overview](#overview)
1. [Usage](#usage)

## Overview

Do you wish your Puppet catalogs didn't contain plain text secrets? Are you tired
of limiting access to your Puppet reports because of the passwords clearly
visible in the change events?

This module will encrypt values for each node specifically, using their own
certificates. This means that not only do you not have plain text secrets, but
each node's can decrypt only its own secrets.

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
encrypted blocks on the CA using the `puppet node encrypt` face.

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

## Disclaimer

I take no liability for the use of this module. 

Contact
-------

binford2k@gmail.com

