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

  action :decrypt do
    summary "Decrypt a value using the agent's own certificate"

    option "-d DATA", "--data DATA" do
      summary "An string of data to decrypt"
    end

    option "-e VARIABLE", "--env VARIABLE" do
      summary "An environment variable containing data to decrypt"
    end

    description <<-'EOT'
      Decrypt a value using the agent's own certificate. You have three ways to pass data
      for decryption. You can pass it directly on the command line (if your kernel allows
      command strings that long), you can set it in an environment variable and pass the
      name of the variable, or you can pipe it using STDIN.
    EOT

    examples <<-'EOT'
      $ puppet node decrypt --data <encrypted blob of data>
      $ puppet node decrypt --env <environment variable containing blob of encrypted data>
      $ echo <encrypted blob of data> | puppet node decrypt
      $ cat /file/with/encrypted/blob.txt | puppet node decrypt
    EOT

    when_invoked do |options|
      if options.include? :data
        Puppet_X::Binford2k::NodeEncrypt.decrypt(options[:data])
      elsif options.include? :env
        Puppet_X::Binford2k::NodeEncrypt.decrypt(ENV[options[:env]])
      else
        Puppet_X::Binford2k::NodeEncrypt.decrypt($stdin.read)
      end
    end
  end

end
