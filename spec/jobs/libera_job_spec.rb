# frozen_string_literal: true

describe LiberaJob do
  let(:pdf) { create(:generic_upload, :pdf) }

  ActiveJob::Base.queue_adapter = :test

  it '' do
  end
end
