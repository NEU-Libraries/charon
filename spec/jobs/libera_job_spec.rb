# frozen_string_literal: true

describe LiberaJob do
  let(:work) { FactoryBot.create_for_repository(:work, :fake_thumbnail) }
  let(:file_set) { FactoryBot.create_for_repository(:file_set) }
  let(:blob) { FactoryBot.create_for_repository(:blob, :pdf) }

  ActiveJob::Base.queue_adapter = :test

  it 'runs the job successfully with a PDF' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      LiberaJob.perform_later(work.noid, blob.noid)
    end.to have_performed_job(LiberaJob)
  end
end
