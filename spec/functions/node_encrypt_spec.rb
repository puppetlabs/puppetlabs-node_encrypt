# frozen_string_literal: true

require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe 'node_encrypt' do
  let(:node) { 'testhost.example.com' }

  it 'exists' do
    expect(Puppet::Parser::Functions.function('node_encrypt')).to eq('function_node_encrypt')
  end

  it 'receives foobar and returns encrypted' do
    expect(PuppetX::Binford2k::NodeEncrypt).to receive(:encrypt).with('foobar', 'testhost.example.com').and_return('encrypted')
    expect(scope.function_node_encrypt(['foobar'])).to eq('encrypted')
  end

  if defined?(Puppet::Pops::Types::PSensitiveType::Sensitive)
    it 'receives sensitive value and returns encrypted' do
      expect(PuppetX::Binford2k::NodeEncrypt).to receive(:encrypt).with('foobar', 'testhost.example.com').and_return('encrypted')
      expect(scope.function_node_encrypt([Puppet::Pops::Types::PSensitiveType::Sensitive.new('foobar')])).to eq('encrypted')
    end
  end
end
