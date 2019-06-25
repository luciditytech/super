require 'spec_helper'

RSpec.describe Super::Struct::Attribute do
  describe '#decode' do
    let(:instance) { Super::Struct::Attribute.new(options) }
    subject { instance.decode(value) }

    shared_context 'and the value is nil' do
      context 'and the value is nil' do
        let(:value) { nil }

        it { is_expected.to be_nil }
      end
    end

    context 'when no decoder or type are defined' do
      let(:options) { {} }

      include_context 'and the value is nil'

      context 'and the value is not nil' do
        let(:value) { 'VALUE' }

        it { is_expected.to eq(value) }
      end
    end

    context 'when a Time is defined' do
      let(:options) { { type: Time } }
      let(:codec) { instance_double(Super::Codecs::TimeCodec) }

      before do
        allow(Super::Codecs::TimeCodec).to receive(:new).and_return(codec)
      end

      include_context 'and the value is nil' do
        before do
          allow(codec).to receive(:decode).with(value).and_return(nil)
        end
      end

      context 'and the value is a Time object' do
        let(:value) { Time.new(2019, 1, 1, 0, 0) }

        before do
          allow(codec).to receive(:decode).with(value).and_return(value)
        end

        it { is_expected.to eq(value) }
      end

      context 'and the value is an ISO8601 String' do
        let(:time) { Time.new(2019, 1, 1, 0, 0) }
        let(:value) { time.iso8601 }

        before do
          allow(codec).to receive(:decode).with(value).and_return(time)
        end

        it { is_expected.to eq(time) }
      end
    end
  end
end
