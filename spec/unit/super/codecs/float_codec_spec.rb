require 'spec_helper'
require 'super/codecs/float_codec'

RSpec.describe Super::Codecs::FloatCodec do
  describe '#decode' do
    let(:instance) { described_class.new }
    subject { instance.decode(value) }

    context 'when value is nil' do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context 'when value is a Float object' do
      let(:value) { Float(1.1) }

      it { is_expected.to eq(value) }
    end

    context 'when value is a String' do
      let(:float) { 1.1 }
      let(:value) { float.to_s }

      it { is_expected.to eq(float) }
    end

    context 'when value is invalid' do
      let(:value) { 'SPACESHIP' }

      it { expect { subject }.to raise_error(Super::Errors::DecodeError) }
    end

    context 'when value can\'t be converted' do
      let(:value) { :spaceship }

      it { expect { subject }.to raise_error(Super::Errors::DecodeError) }
    end
  end
end
