require 'puppet_x/binford2k/node_encrypt'

Puppet::Type.newtype(:node_encrypted_file) do
  desc "Manage the content of a file by decrypting with the agent certificate"

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      raise Puppet::ParseError, 'The node_encrypted_file type does not support removal. Use the File type.'
    end
  end

  newparam(:path, :namevar => true) do
    desc 'The path of the managed file'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::ParseError, "Paths must be fully qualified, not '#{value}'"
      end
    end
  end

  newproperty(:content) do
    desc 'Content for the file encrypted with the node_encrypt() function.'

    validate do |value|
      unless Puppet_X::Binford2k::NodeEncrypt.encrypted? value
        raise Puppet::ParseError, 'Pass only encrypted ciphertext to node_encrypted_file.'
      end
    end

    munge do |value|
      # This happens on the agent side, so yay?
      Puppet_X::Binford2k::NodeEncrypt::Value.new(value)
    end
  end
end
