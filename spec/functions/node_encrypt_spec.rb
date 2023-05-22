require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe 'node_encrypt' do
  let(:node) { 'testhost.example.com' }

  it {
    expect(PuppetX::BinFord2k::NodeEncrypt).to receive(:encrypt).with('foobar', 'testhost.example.com').and_return('encrypted')
    is_expected.to run.with_params('foobar').and_return('encrypted')
  }

  if defined?(Puppet::Pops::Types::PSensitiveType::Sensitive)
    it {
      expect(PuppetX::BinFord2k::NodeEncrypt).to receive(:encrypt).with('foobar', 'testhost.example.com').and_return('encrypted')
      is_expected.to run.with_params(Puppet::Pops::Types::PSensitiveType::Sensitive.new('foobar')).and_return('encrypted')
    }
  end
end
