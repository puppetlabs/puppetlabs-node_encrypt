require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe "node_encrypt::certificates" do

  context "when run on the CA" do
    let(:node) { 'ca.example.com' }
    let(:facts) { {
      :fqdn     => 'ca.example.com',
      :settings => { # TODO: these don't seem to work...
                    'ca_server'  => 'ca.example.com',
                    'confdir'    => '/etc/puppetlabs/puppet',
                    'servername' => 'ca.example.com',
                    'ssldir'     => '/etc/puppetlabs/puppet'
                   },
    } }

    it {
      should contain_ini_setting('public certificates mountpoint path').with({
        :ensure => 'present',
        :path   => '/etc/puppetlabs/puppet/fileserver.conf',
        :value  => '/etc/puppetlabs/puppet/ssl/ca/signed',
      })
    }

    it {
      should contain_ini_setting('public certificates mountpoint whitelist').with({
        :ensure => 'present',
        :path   => '/etc/puppetlabs/puppet/fileserver.conf',
        :value  => '*',
      })
    }

    it { should_not contain_file('/etc/puppetlabs/puppet/ssl/certs') }
  end

  context "when run on a compile master" do
    let(:node) { 'compile1.example.com' }
    let(:facts) { {
      :fqdn     => 'compile1.example.com',
      :settings => {
                    'ca_server'  => 'ca.example.com',
                    'confdir'    => '/etc/puppetlabs/puppet',
                    'servername' => 'ca.example.com',
                    'ssldir'     => '/etc/puppetlabs/puppet/ssl'
                   },
    } }

    it { should_not contain_ini_setting('public certificates mountpoint path') }

    it { should_not contain_ini_setting('public certificates mountpoint whitelist') }

    it {
      should contain_file('/etc/puppetlabs/puppet/ssl/certs').with({
        :ensure => 'directory',
        :source => 'puppet://ca.example.com/public_certificates/',
      })
    }
  end

  context "when run on a tier3 agent" do
    let(:node) { 'agent.example.com' }
    let(:facts) { {
      :fqdn     => 'agent.example.com',
      :settings => {
                    'ca_server'  => 'ca.example.com',
                    'confdir'    => '/etc/puppetlabs/puppet',
                    'servername' => 'compile1.example.com',
                    'ssldir'     => '/etc/puppetlabs/puppet/ssl'
                   },
    } }

    it { should_not contain_ini_setting('public certificates mountpoint path') }
    it { should_not contain_ini_setting('public certificates mountpoint whitelist') }
    it { should_not contain_file('/etc/puppetlabs/puppet/ssl/certs') }

  end

end
