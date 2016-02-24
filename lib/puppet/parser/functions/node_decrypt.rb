require 'puppet_x/binford2k/node_encrypt'

Puppet::Parser::Functions::newfunction(:node_decrypt,
  :type  => :rvalue,
  :arity => 1,
) do |args|
  content  = args.first
  value = Puppet_X::Binford2k::NodeEncrypt::Value.new(content).decrypted_value
end
