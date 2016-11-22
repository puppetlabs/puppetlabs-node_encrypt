require 'puppet/face'
require 'puppet_x/binford2k/node_encrypt'

Puppet::Face.define(:node, '0.0.1') do
  action :decrypt do
    summary "Decrypt a encrypted value encrypted by node-encrypt"

    option "-e" ENV_VAR, "--env-var ENV_VAR" do
      summary "Variable to use that contains the encrypted value.  Same as --hash_value
      but references the variable instead"

    end
    option "-k LONG_HASH", "--hash_value LONG_HASH" do
      summary "The thing you want to decrypt"
    end

    when_invoked do |options|
      Puppet_X::Binford2k::NodeEncrypt.decrypt(options[:hash_value])
    end

    description <<-'EOT'
      Decrypt a encrypted secret by using the agent's private certificate. Useful for inline
      decryption in a resource statement.

      This will only run properly when run the user running the command has access
      to the private certificate. This command will use the default private key specified
      by the puppet config.
    EOT

    examples <<-'EOT'
      $ puppet node decrypt $SOME_LONG_HASH
    EOT
  end
end
