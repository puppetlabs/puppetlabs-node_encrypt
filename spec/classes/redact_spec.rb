require 'spec_helper'

describe "redact" do
  let(:node) { 'test.example.com' }
  let(:facts) { {
    :fqdn     => 'test.example.com',
  } }
  let(:params) { {
    :param    => 'a param',
    :redacted => 'to be redacted',
    :replaced => 'to be replaced',
  } }

  it { is_expected.to contain_class('redact').with({
      :param    => 'a param',
      :redacted => '<<redacted>>',
      :replaced => 'a replacement string',
    })
  }
  it { is_expected.to contain_redact__thing('one').with({
      :param    => 'a param',
      :redacted => '<<redacted>>',
      :replaced => 'a replacement string',
    })
  }
  it { is_expected.to contain_redact__thing('two').with({
      :param    => 'a param',
      :redacted => '<<redacted>>',
      :replaced => 'a replacement string',
    })
  }
  it { is_expected.to contain_redact__thing('three').with({
      :param    => 'a param',
      :redacted => '<<redacted>>',
      :replaced => 'a replacement string',
    })
  }
  it { is_expected.to contain_redact__thing('four').with({
      :param    => 'a param',
      :redacted => '<<redacted>>',
      :replaced => 'a replacement string',
    })
  }

  describe 'parameters being redacted are still available to use in manifests' do
    ['one','two','three','four'].each do |title|
      it { is_expected.to contain_notify("#{title} The value of redacted is to be redacted") }
      it { is_expected.to contain_notify("#{title} The value of replaced is to be replaced") }
    end
  end
end
