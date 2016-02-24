require 'puppet_x/binford2k/node_encrypt'

Puppet::Parser::Functions::newfunction(:node_encrypt,
  :type  => :rvalue,
  :arity => -1,
) do |args|
  content  = args.first
  certname = args[1] || self.lookupvar('clientcert')
  Puppet_X::Binford2k::NodeEncrypt.encrypt(content, certname)
end
