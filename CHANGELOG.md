# 0.2.0

* Allow this to work on nodes that are not the CA. (Requires some setup.)

# 0.1.2

* Erm. Actually include the bit that removes the content from the catalog.
* Added an `autobefore` to ensure this always lets a file resource correct
  out of sync parameters, if one is declared.

# 0.1.1

* Validate that plaintext is not passed to node_encrypted_file.
* Add ability to pass pre-encrypted ciphertext to node_encrypt::file.
* More docs and better specs.

#0.1.0

* Initial release.
