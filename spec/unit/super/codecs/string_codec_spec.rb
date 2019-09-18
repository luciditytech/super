require 'spec_helper'
require 'super/codecs/string_codec'

RSpec.describe Super::Codecs::StringCodec do
  describe '#decode' do
    let(:instance) { described_class.new }
    subject { instance.decode(value) }

    context 'when value is nil' do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context 'when value is a String object' do
      let(:value) { 'my string' }

      it { is_expected.to eq(value) }
    end

    context 'when value is invalid' do
      class DummyClass
        undef :to_s
      end

      let(:value) { DummyClass.new }

      it { expect { subject }.to raise_error(Super::Errors::DecodeError) }
    end
  end
end
