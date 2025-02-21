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

    context 'when a type without a codec is defined' do
      context 'and type has a native decode method' do
        class DummyClass
          include Super::Struct
          attribute :id, type: String
        end

        let(:options) { { type: DummyClass } }

        include_context 'and the value is nil'

        context 'and the value is the same type' do
          let(:value) { DummyClass.new }

          it { is_expected.to eq(value) }
        end

        context 'and the value is an attribute hash' do
          let(:value) { { id: '1' } }

          it { is_expected.to be_a(DummyClass) }
        end
      end

      context 'and type does not have a native decode method' do
        let(:options) { { type: Date } }

        include_context 'and the value is nil'

        context 'and the value is not nil' do
          let(:value) { Date.new(2019, 6, 26) }

          it { is_expected.to eq(value) }
        end
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

    context 'when a Float is defined' do
      let(:options) { { type: Float } }

      include_context 'and the value is nil'

      context 'and the value is a Float object' do
        let(:value) { 1.1 }

        it { is_expected.to eq(value) }
      end

      context 'and the value is a String' do
        let(:float) { 1.1 }
        let(:value) { float.to_s }

        it { expect { subject }.to raise_error(Super::Errors::DecodeError) }
      end
    end

    context 'when a String is defined' do
      let(:options) { { type: String } }

      include_context 'and the value is nil'

      context 'and the value is a String object' do
        let(:value) { 'my string' }

        it { is_expected.to eq(value) }
      end

      context 'and the value is a convertable type' do
        let(:value) { 100 }

        it { is_expected.to eq(value.to_s) }
      end

      context 'and the value is not a convertable type' do
        class NewDummyClass
          undef :to_s
        end

        let(:value) { NewDummyClass.new }

        it { expect { subject }.to raise_error(Super::Errors::DecodeError) }
      end
    end
  end
end
