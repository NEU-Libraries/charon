# frozen_string_literal: true

describe SearchBuilder do
  it 'is a subclass of Blacklight::SearchBuilder' do
    expect(described_class < Blacklight::SearchBuilder).to be true
  end
end
