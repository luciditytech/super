require 'spec_helper'
require 'super/struct'

RSpec.describe Super::Struct do
  describe '.new' do
    context 'inheritance' do
      class ParentModel
        include Super::Struct

        attribute :id, type: String
      end

      class ChildModel < ParentModel
        attribute :role, type: String
      end

      subject { ParentModel.new }

      it { is_expected.to be_an_instance_of(ParentModel) }

      it 'includes a role attribute in the child\'s schema' do
        expect(ChildModel.schema[:role]).to_not be_nil
      end
    end
  end
end
