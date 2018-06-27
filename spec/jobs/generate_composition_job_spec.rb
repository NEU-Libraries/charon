require "rails_helper"

RSpec.describe GenerateCompositionJob, type: :job do
  include ActiveJob::TestHelper

  let(:composition) { Composition.create(:title => ["Test Composition"]) }
  # subject(:job) { described_class.perform_later(composition.id, "", "") }

  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      GenerateCompositionJob.perform_later
    }.to have_enqueued_job(GenerateCompositionJob)
  end

  it "creates a new composition" do
    expect(composition.title).to eq(["Test Composition"])
  end

  it "creates pages" do
  end
end
