# 0.2.7

* Allow the `redact()` function to work with defined types. (ross-w)

# 0.2.6

* Correctly handle namespace capitalization (JeremyEinfeld)
* Use $path parameter properly
* Corrected some spec tests
* Warn when signature verification fails

# 0.2.5

* Added a `redact()` function to remove class parameters from the catalog.

# 0.2.4

* Reimplements `autobefore` on masters that don't support it. This corrects
  incompatibilities with 3.x masters.

# 0.2.3

* Adds command-line decrypt tool. This can be used in scripts or in `exec`
  resources.

# 0.2.2

* Synchronize certificates in a more robust way. The CA node will encrypt
  using certificates in the CA store so that no setup is required, but compile
  masters will encrypt using their own host certificate and synchronized agent
  certificates. This requires classification with `node_encrypt::certificates`.
* Simpler and more robust role detection. Works in standalone and in MoM setups.
* Use the CA verify chain on the agent.
* Stop playing with strings and just use the built-in `Puppet.settings`.

# 0.2.1

* Working around a *possibly* broken fqdn is probably just a real bad idea.
  This simplifies the CA node identification logic and removes the poorly
  thought out `ca_node` parameter that lasted for less than 24 hours.

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
