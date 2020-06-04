# frozen_string_literal: true

describe CreateThumbnailJob do
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:image) { create(:generic_upload) }
  let(:pdf) { create(:generic_upload, :pdf) }
  let(:file_set) { FactoryBot.create_for_repository(:file_set, :blank) }

  ActiveJob::Base.queue_adapter = :test

  it 'runs the job successfully with an image' do
    # TODO: check that derivatives are actually created
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateThumbnailJob.perform_later(image.id, work.noid, file_set.noid)
    end.to have_performed_job(CreateThumbnailJob)
  end

  it 'runs the job successfully with a PDF' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateThumbnailJob.perform_later(pdf.id, work.noid, file_set.noid)
    end.to have_performed_job(CreateThumbnailJob)
  end

  it 'exits gracefully if params refer to missing objects' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateThumbnailJob.perform_later('', '', '')
    end.to have_performed_job(CreateThumbnailJob)
  end

  it 'is idempotent' do
    # TODO: update when this actually works
  end
end
