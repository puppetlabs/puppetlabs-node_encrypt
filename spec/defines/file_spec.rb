require 'spec_helper'
require 'PuppetX/BinFord2k/node_encrypt'

describe 'node_encrypt::file' do
  context 'ensuring present' do
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
      is_expected.to contain_file('/tmp/test').with({
                                                      ensure: 'file',
      owner: 'root',
      mode: '0644',
      content: 'encrypted',
                                                    })
    }
  end

  context 'should accept pre-encrypted content' do
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
      PuppetX::BinFord2k::NodeEncrypt.stubs(:decrypt).with('encrypted').returns('decrypted')
    end

    it { is_expected.to have_notify_resource_count(1) }
    it {
      is_expected.to contain_file('/tmp/test').with({
                                                      ensure: 'file',
      owner: 'root',
      mode: '0644',
      content: sensitive('decrypted'),
                                                    })
    }
  end

  context 'ensure absent' do
    let(:title) { '/tmp/test' }
    let(:params) { { ensure: 'absent' } }

    it { is_expected.to have_notify_resource_count(1) }
    it { is_expected.to contain_file('/tmp/test').with_ensure('absent') }
  end
end
