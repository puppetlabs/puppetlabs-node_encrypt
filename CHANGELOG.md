<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v2.0.0](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v2.0.0) - 2022-10-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v1.0.0...v2.0.0)

## [v1.0.0](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v1.0.0) - 2022-10-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.4.1...v1.0.0)

### Added

- Add support for mocking (Onceover/rspec) [#70](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/70) ([alexjfisher](https://github.com/alexjfisher))

### Changed
- Remove legacy support. This now requires Puppet 6.x+ [#82](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/82) ([binford2k](https://github.com/binford2k))

### Fixed

- pdk apparently requires you to manually ignore .git [#83](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/83) ([binford2k](https://github.com/binford2k))
- Fix redacting shared defined type parameters [#75](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/75) ([alexjfisher](https://github.com/alexjfisher))

## [v0.4.1](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.4.1) - 2019-08-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.4.0...v0.4.1)

### Fixed

- Allow node_encrypt::secret to accept Sensitive[String] values [#52](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/52) ([danielparks](https://github.com/danielparks))

## [v0.4.0](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.4.0) - 2019-01-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.3.3...v0.4.0)

### Added

- Use client certs from the CA if they exist [#48](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/48) ([binford2k](https://github.com/binford2k))
- Disable verification for Puppet 6 certificate chain [#41](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/41) ([binford2k](https://github.com/binford2k))
- Try a different approach to determining what certs to use [#37](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/37) ([binford2k](https://github.com/binford2k))

### Fixed

- Add alternate of sending clientcert as fact [#49](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/49) ([binford2k](https://github.com/binford2k))

## [v0.3.3](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.3.3) - 2018-06-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.3.1...v0.3.3)

### Fixed

- This should be a != compare as if the node's puppet server is not the… [#28](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/28) ([dustinak](https://github.com/dustinak))

## [v0.3.1](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.3.1) - 2017-11-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.3.0...v0.3.1)

## [v0.3.0](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.3.0) - 2017-10-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.7...v0.3.0)

### Added

- Add Puppet 5 support to the certificates class [#23](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/23) ([binford2k](https://github.com/binford2k))
- node_encrypt.rb: Use dummy 4 byte password to read key. [#20](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/20) ([olifre](https://github.com/olifre))

### Fixed

- Use pseudo-relative include paths in parser-function and type. [#19](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/19) ([olifre](https://github.com/olifre))

## [v0.2.7](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.7) - 2017-06-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.6...v0.2.7)

### Added

- Allow redact to take defines as well as classes [#17](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/17) ([ross-w](https://github.com/ross-w))

## [v0.2.6](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.6) - 2017-06-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.5...v0.2.6)

## [v0.2.5](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.5) - 2016-04-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.4...v0.2.5)

## [v0.2.4](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.4) - 2016-03-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.3...v0.2.4)

## [v0.2.3](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.3) - 2016-02-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.2...v0.2.3)

## [v0.2.2](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.2) - 2015-12-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.2.1...v0.2.2)

## [v0.2.1](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.2.1) - 2015-12-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.1.2...v0.2.1)

### Added

- Allow to run on non-CA nodes. Requires setup. [#2](https://github.com/puppetlabs/puppetlabs-node_encrypt/pull/2) ([binford2k](https://github.com/binford2k))

## [v0.1.2](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.1.2) - 2015-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.1.1...v0.1.2)

## [v0.1.1](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.1.1) - 2015-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/v0.1.0...v0.1.1)

## [v0.1.0](https://github.com/puppetlabs/puppetlabs-node_encrypt/tree/v0.1.0) - 2015-12-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-node_encrypt/compare/edf02937dbb441fc254aa0e9939fb94fca0edb10...v0.1.0)
