# frozen_string_literal: true

describe ApplicationJob do
  it 'is a subclass of ActiveJob::Base' do
    expect(described_class < ActiveJob::Base).to be true
  end
end
