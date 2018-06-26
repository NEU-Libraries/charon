require "rails_helper"

RSpec.describe GenerateCompositionJob do
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      GenerateCompositionJob.perform_later
    }.to have_enqueued_job(GenerateCompositionJob)
  end
end
