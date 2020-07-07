# frozen_string_literal: true

describe CreateBlobJob do
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:image) { create(:generic_upload) }
  let(:pdf) { create(:generic_upload, :pdf) }
  let(:blank_file_set) { FactoryBot.create_for_repository(:file_set, :blank) }
  let(:file_set) { FactoryBot.create_for_repository(:file_set) }

  ActiveJob::Base.queue_adapter = :test

  it 'runs the job successfully with an image' do
    # TODO: check that derivatives are actually created
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateBlobJob.perform_later(work.noid, image.id, blank_file_set.noid)
    end.to have_performed_job(CreateBlobJob)
  end

  it 'runs the job successfully with a PDF' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect(pdf.file_name).to eq('example.pdf')
    expect do
      CreateBlobJob.perform_later(work.noid, pdf.id, blank_file_set.noid)
    end.to have_performed_job(CreateBlobJob)
  end

  it 'exits gracefully if params refer to missing objects' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateBlobJob.perform_later('', '', '')
    end.to have_performed_job(CreateBlobJob)
  end

  it 'exits gracefully if file set already has original file' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    expect do
      CreateBlobJob.perform_later(work.noid, image.id, file_set.noid)
    end.to have_performed_job(CreateBlobJob)
  end

  it 'is idempotent' do
    # TODO: update when this actually works
  end
end
