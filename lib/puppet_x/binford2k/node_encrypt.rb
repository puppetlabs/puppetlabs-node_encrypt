module Puppet_X
  module Binford2k
    class NodeEncrypt

      def self.encrypted?(data)
        # ridiculously faster than a regex
        data.start_with?("-----BEGIN PKCS7-----")
      end

      def self.encrypt(data, destination)
        raise ArgumentError, 'Can only encrypt strings' unless data.class == String
        raise ArgumentError, 'Need a node name to encrypt for' unless destination.class == String

        ssldir   = Puppet.settings[:ssldir]
        name     = Puppet.settings[:certname]
        cert     = OpenSSL::X509::Certificate.new(File.read("#{ssldir}/certs/ca.pem"))
        key      = OpenSSL::PKey::RSA.new(File.read("#{ssldir}/private_keys/#{name}.pem"), '')
        target   = OpenSSL::X509::Certificate.new(File.read("#{ssldir}/ca/signed/#{destination}.pem")) rescue nil
        target ||= OpenSSL::X509::Certificate.new(File.read("#{ssldir}/certs/#{destination}.pem")) # if using auto distributed certs

        signed = OpenSSL::PKCS7::sign(cert, key, data, [], OpenSSL::PKCS7::BINARY)
        cipher = OpenSSL::Cipher::new("AES-128-CFB")

        OpenSSL::PKCS7::encrypt([target], signed.to_der, cipher, OpenSSL::PKCS7::BINARY).to_s
      end

      def self.decrypt(data)
        raise ArgumentError, 'Can only decrypt strings' unless data.class == String

        ssldir = Puppet.settings[:ssldir]
        name   = Puppet.settings[:certname]
        cert   = OpenSSL::X509::Certificate.new(File.read("#{ssldir}/certs/#{name}.pem"))
        key    = OpenSSL::PKey::RSA.new(File.read("#{ssldir}/private_keys/#{name}.pem"), '')
        source = OpenSSL::X509::Certificate.new(File.read("#{ssldir}/certs/ca.pem"))

        store = OpenSSL::X509::Store.new
        store.add_cert(source)

        blob      = OpenSSL::PKCS7.new(data)
        decrypted = blob.decrypt(key, cert)
        verified  = OpenSSL::PKCS7.new(decrypted)

        verified.verify(nil, store, nil, OpenSSL::PKCS7::NOVERIFY)
        verified.data
      end

      # This is just a stupid simple value wrapper class that allows us to store and compare
      # two values, but to not print them out in the generated reports.
      class Value
        attr_accessor :decrypted_value

        def initialize(value)
          if Puppet_X::Binford2k::NodeEncrypt.encrypted? value
            @decrypted_value = Puppet_X::Binford2k::NodeEncrypt.decrypt(value)
          else
            @decrypted_value = value
          end
        end

        def == (another)
          # Puppet does some weird comparisons, so let's just short circuit them all
          return false unless another.class == Puppet_X::Binford2k::NodeEncrypt::Value
          @decrypted_value == another.decrypted_value
        end

        def to_s
          '<<encrypted>>'
        end
      end

    end
  end
end