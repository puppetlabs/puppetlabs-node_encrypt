require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe "node_encrypt::certificates" do

  before(:each) do
    Puppet[:ca_server] = 'ca.example.com'
    Puppet[:confdir]   = '/etc/puppetlabs/puppet'
    Puppet[:ssldir]    = '/etc/puppetlabs/puppet/ssl'
  end

  context "when run on the CA" do
# Test case don't work? Comment it, yo! http://i.imgur.com/ki41AH1.gifv

    let(:node) { 'ca.example.com' }
    let(:facts) { {
      :fqdn       => 'ca.example.com',
      :servername => 'ca.example.com',
    } }

    it {
      should contain_ini_setting('public certificates mountpoint path').with({
        :ensure => 'present',
        :path   => '/etc/puppetlabs/puppet/fileserver.conf',
        :value  => '/etc/puppetlabs/puppet/ssl/ca/signed/',
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
      :fqdn       => 'compile1.example.com',
      :servername => 'ca.example.com',
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
      :fqdn       => 'agent.example.com',
      :servername => 'compile01.example.com',
    } }

    it { should_not contain_ini_setting('public certificates mountpoint path') }
    it { should_not contain_ini_setting('public certificates mountpoint whitelist') }
    it { should_not contain_file('/etc/puppetlabs/puppet/ssl/certs') }

  end

end
