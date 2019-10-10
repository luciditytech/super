require 'spec_helper'
require 'super/serializer'

RSpec.describe Super::Serializer do
  describe '.new' do
    context 'inheritance' do
      class ParentSerializer
        include Super::Serializer

        attribute :id, type: String
      end

      class ChildSerializer < ParentSerializer
        attribute :role, type: String
      end

      subject { ParentSerializer.new }

      it { is_expected.to be_an_instance_of(ParentSerializer) }

      it 'includes a role attribute in the child\'s schema' do
        expect(ChildSerializer.schema[:attributes][:role]).to_not be_nil
      end
    end
  end
end
