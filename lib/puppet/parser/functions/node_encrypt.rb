require File.join(File.dirname(__FILE__), '../../..', 'puppet_x/binford2k/node_encrypt.rb')

Puppet::Parser::Functions::newfunction(:node_encrypt,
  :type  => :rvalue,
  :arity => 1,
  :doc   => <<DOC
This function simply encrypts the string passed to it using the certificate
belonging to the client the catalog is being compiled for.
DOC
) do |args|
  content  = args.first
  certname = self.lookupvar('clientcert')
  Puppet_X::Binford2k::NodeEncrypt.encrypt(content, certname)
end
