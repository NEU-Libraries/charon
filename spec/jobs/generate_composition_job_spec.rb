require "rails_helper"

RSpec.describe GenerateCompositionJob do
  before(:all) do
    ActiveFedora::Cleaner.clean!
    # @master = GenerateCompositionJob.new(composition_id, pdf_location, working_dir).run
  end

  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      GenerateCompositionJob.perform_later
    }.to have_enqueued_job(GenerateCompositionJob)
  end

  it "creates a new composition" do
  end

  it "creates pages" do
  end
end
