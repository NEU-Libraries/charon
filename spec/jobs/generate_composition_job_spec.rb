require "rails_helper"

RSpec.describe GenerateCompositionJob, type: :job do
  include ActiveJob::TestHelper

  let(:composition) { Composition.create(:title => ["Test Composition"]) }
  subject(:job) { described_class.perform_later(composition.id, "#{Rails.root}/spec/fixtures/files/test.pdf", "#{Rails.root}/tmp/GenerateCompositionJobTest") }

  before(:all) do
    Libera.configuration.working_dir = "#{Rails.root}/tmp/GenerateCompositionJobTest"
    if File.directory?(Libera.configuration.working_dir)
      FileUtils.rm_rf(Libera.configuration.working_dir)
    end
    FileUtils.mkdir(Libera.configuration.working_dir)
  end

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
    perform_enqueued_jobs { job }
    puts "DGC DEBUG"
    puts composition.inspect
  end
end
