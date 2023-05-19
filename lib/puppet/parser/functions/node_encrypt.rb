require_relative '../../../PuppetX/BinFord2k/node_encrypt'

Puppet::Parser::Functions.newfunction(:node_encrypt,
  type: :rvalue,
  arity: 1,
  doc: <<DOC,
This function simply encrypts the String or Sensitive passed to it using the certificate
belonging to the client the catalog is being compiled for.
DOC
) do |args|
  content = args.first
  content = if defined?(Puppet::Pops::Types::PSensitiveType::Sensitive) && content.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
              content.unwrap
            else
              content
            end

  certname = lookupvar('clientcert')
  PuppetX::BinFord2k::NodeEncrypt.encrypt(content, certname)
end
