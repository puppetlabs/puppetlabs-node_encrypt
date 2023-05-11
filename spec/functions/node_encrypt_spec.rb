require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe 'node_encrypt' do
  let(:node) { 'testhost.example.com' }

  it {
    expect(Puppet_X::Binford2k::NodeEncrypt).to receive(:encrypt).with('foobar','testhost.example.com').and_return('encrypted')
    should run.with_params('foobar').and_return('encrypted')
  }

  if defined?(Puppet::Pops::Types::PSensitiveType::Sensitive)
    it {
      expect(Puppet_X::Binford2k::NodeEncrypt).to receive(:encrypt).with('foobar','testhost.example.com').and_return('encrypted')
      should run.with_params(Puppet::Pops::Types::PSensitiveType::Sensitive.new('foobar')).and_return('encrypted')
    }
  end
end
