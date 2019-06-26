require 'spec_helper'
require 'super/codecs/time_codec'

RSpec.describe Super::Codecs::TimeCodec do
  describe '#decode' do
    let(:instance) { described_class.new }
    subject { instance.decode(value) }

    context 'when value is nil' do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context 'when value is a Time object' do
      let(:value) { Time.new(2019, 1, 1, 0, 0) }

      it { is_expected.to eq(value) }
    end

    context 'when value is an ISO8601 String' do
      let(:time) { Time.new(2019, 1, 1, 0, 0) }
      let(:value) { time.iso8601 }

      it { is_expected.to eq(time) }
    end

    context 'when value is invalid' do
      let(:value) { 'SPACESHIP' }

      it { expect { subject }.to raise_error(Super::Errors::DecodeError) }
    end
  end
end
