# frozen_string_literal: true

require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe 'node_encrypt::file' do
  context 'when ensuring present' do
    let(:node) { 'testhost.example.com' }
    let(:title) { '/tmp/test' }
    let(:params) do
      {
        ensure: 'file',
        owner: 'root',
        mode: '0644',
        content: 'foobar'
      }
    end

    let(:pre_condition) do
      'function node_encrypt::secret($data) { return "encrypted" }'
    end

    it { is_expected.to have_notify_resource_count(1) }

    it {
      expect(subject).to contain_file('/tmp/test').with(
        {
          ensure: 'file',
          owner: 'root',
          mode: '0644',
          content: 'encrypted'
        },
      )
    }
  end

  context 'with pre-encrypted content',
          skip: 'skipping due to difference in behaviour between mocha stub and rspec allow on ruby 2.x, and the defined type node_encrypt::file is to be removed in a seperate PR' do
    let(:node) { 'testhost.example.com' }
    let(:title) { '/tmp/test' }
    let(:params) do
      {
        ensure: 'file',
        owner: 'root',
        mode: '0644',
        encrypted_content: 'encrypted'
      }
    end

    before(:each) do
      allow(PuppetX::Binford2k::NodeEncrypt).to receive(:decrypt).with('encrypted').and_return('decrypted')
    end

    it {
      expect(subject).to have_notify_resource_count(1)
    }

    it { is_expected.to have_notify_resource_count(1) }

    it {
      expect(subject).to contain_file('/tmp/test').with(
        {
          ensure: 'file',
          owner: 'root',
          mode: '0644',
          content: sensitive('decrypted')
        },
      )
    }
  end

  context 'when ensure absent' do
    let(:title) { '/tmp/test' }
    let(:params) { { ensure: 'absent' } }

    it { is_expected.to have_notify_resource_count(1) }
    it { is_expected.to contain_file('/tmp/test').with_ensure('absent') }
  end
end
