require 'spec_helper'
require 'super/resource_pool'

RSpec.describe Super::ResourcePool do
  describe '#with' do
    subject { instance.with(timeout: 0, max_tries: 1, &:touch) }

    let(:instance) do
      described_class.new(size: size) { resource }
    end

    let(:resource) { double(touch: true) }

    context 'when there are resources available' do
      let(:size) { 1 }

      it 'yields a pool resource' do
        expect { |b| instance.with(&b) }.to yield_with_args(resource)
      end

      it 'allows access to a pool resource' do
        expect(resource).to receive(:touch)
        subject
      end
    end

    context 'when there are no resources available' do
      let(:size) { 1 }
      let(:error) { Super::ResourcePool::NoAvailableResourceError }

      before do
        instance.pop
      end

      it { expect { subject }.to raise_error(error) }
    end
  end
end
