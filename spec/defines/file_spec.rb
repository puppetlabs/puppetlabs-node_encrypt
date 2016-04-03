require 'spec_helper'
require 'puppet_x/binford2k/node_encrypt'

describe "node_encrypt::file" do
#
# TODO: I don't know why this spec makes other specs barf. :(
#
#   context "ensuring present" do
#     let(:node) { 'testhost.example.com' }
#     let(:title) { '/tmp/test' }
#     let(:params) { {
#       :ensure  => 'file',
#       :owner   => 'root',
#       :mode    => '0644',
#       :content => 'foobar'
#     } }
#     Puppet_X::Binford2k::NodeEncrypt.expects(:encrypt).with('foobar','testhost.example.com').returns('encrypted')
#
#     it { should contain_file('/tmp/test').with({
#       :ensure  => 'file',
#       :owner   => 'root',
#       :mode    => '0644',
#     }).without_content() }
#
#     it { should contain_node_encrypted_file('/tmp/test')
#       .with_content('encrypted')
#       .that_comes_before('File[/tmp/test]')
#     }
#   end

  context "should accept pre-encrypted content" do
    let(:title) { '/tmp/test' }
    let(:params) { {
      :ensure            => 'file',
      :owner             => 'root',
      :mode              => '0644',
      :encrypted_content => 'encrypted'
    } }

    it { should contain_node_encrypted_file('/tmp/test')
      .with_content('encrypted')
      .that_comes_before('File[/tmp/test]')
    }
  end

  context "ensure absent" do
    let(:title) { '/tmp/test' }
    let(:params) { { :ensure => 'absent' } }
    it { should contain_file('/tmp/test').with_ensure('absent') }
    it { should_not contain_node_encrypted_file('/tmp/test') }
  end

end
