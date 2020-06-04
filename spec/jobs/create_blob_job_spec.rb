# frozen_string_literal: true

describe CreateBlobJob do
  subject(:job) { described_class.perform_later('x', 'y') }
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:image) { create(:generic_upload) }
  let(:pdf) { create(:generic_upload, :pdf) }
  let(:file_set) { FactoryBot.create_for_repository(:file_set) }

  ActiveJob::Base.queue_adapter = :test

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with('x', 'y')
      .on_queue('default')
  end

  it 'runs the job successfully with an image' do
    # TODO: check that derivatives are actually created
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateBlobJob.perform_later(work.noid, image.id, file_set.noid)
    end.to have_performed_job(CreateBlobJob)
  end

  it 'runs the job successfully with a PDF' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateBlobJob.perform_later(work.noid, pdf.id, file_set.noid)
    end.to have_performed_job(CreateBlobJob)
  end

  it 'is idempotent' do
    # TODO: update when this actually works
  end
end
