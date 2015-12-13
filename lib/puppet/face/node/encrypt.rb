require 'puppet/face'
require 'puppet_x/binford2k/node_encrypt'

Puppet::Face.define(:node, '0.0.1') do
  action :encrypt do
    summary "Encrypt a value using a specified agent's certificate"
    arguments "<string>"

    option "-t CERTNAME", "--target CERTNAME" do
      summary "Which agent to encrypt for"
    end

    description <<-'EOT'
      Encrypt a value using a specified agent's certificate useful for pasting
      into a manifest for a node_encrypted_file resource type, or for a data
      value for a datacat fragment.

      This will only run properly on a CA node with access to each node's signed
      public certificate.
    EOT

    examples <<-'EOT'
      $ puppet node encrypt --certname testhost.example.com "some text to encrypt"
    EOT

    when_invoked do |text, options|
      Puppet_X::Binford2k::NodeEncrypt.encrypt(text, options[:target])
    end
  end
end
