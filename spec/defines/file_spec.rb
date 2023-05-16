require 'spec_helper'
require 'puppet_x/puppetlabs/node_encrypt'

describe "node_encrypt::file" do
  context "ensuring present" do
    let(:node) { 'testhost.example.com' }
    let(:title) { '/tmp/test' }
    let(:params) { {
      :ensure  => 'file',
      :owner   => 'root',
      :mode    => '0644',
      :content => 'foobar'
    } }

    let(:pre_condition) do
      'function node_encrypt::secret($data) { return "encrypted" }'
    end

    it { should have_notify_resource_count(1) }
    it { should contain_file('/tmp/test').with({
      :ensure  => 'file',
      :owner   => 'root',
      :mode    => '0644',
      :content => 'encrypted',
    })}
  end

  context "should accept pre-encrypted content" do
    let(:node) { 'testhost.example.com' }
    let(:title) { '/tmp/test' }
    let(:params) { {
      :ensure            => 'file',
      :owner             => 'root',
      :mode              => '0644',
      :encrypted_content => 'encrypted'
    } }

    before(:each) do
      allow(Puppet_X::Puppetlabs::NodeEncrypt).to receive(:decrypt).with('encrypted').and_return('decrypted')
    end

    it { should have_notify_resource_count(1) }
    it { should contain_file('/tmp/test').with({
      :ensure  => 'file',
      :owner   => 'root',
      :mode    => '0644',
      :content => sensitive('decrypted'),
    })}
  end

  context "ensure absent" do
    let(:title) { '/tmp/test' }
    let(:params) { { :ensure => 'absent' } }
    it { should have_notify_resource_count(1) }
    it { should contain_file('/tmp/test').with_ensure('absent') }
  end
end
