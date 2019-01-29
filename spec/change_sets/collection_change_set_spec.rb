require "rails_helper"
require "valkyrie/specs/shared_specs"

describe CollectionChangeSet do
  let(:resource_klass) { described_class }
  let(:change_set) { described_class.new(Collection.new) }

  it_behaves_like 'a Valkyrie::ChangeSet'

  it "allows setting title and a_member_of" do
    expect(change_set.validate(title: 'Abc', a_member_of: ['123', '345'])).to be true
  end
end
