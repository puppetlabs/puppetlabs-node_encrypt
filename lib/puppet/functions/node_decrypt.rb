require_relative '../../PuppetX/BinFord2k/node_encrypt'

# Decrypt data with node_encrypt. This is intended to be used as a
# Deferred function on the _agent_ via the node_encrypted::secret wrapper.
#
Puppet::Functions.create_function(:node_decrypt) do
  dispatch :decrypt do
    param 'String', :content
  end

  def decrypt(content)
    Puppet::Pops::Types::PSensitiveType::Sensitive.new(
      PuppetX::BinFord2k::NodeEncrypt.decrypt(content),
    )
  end
end
