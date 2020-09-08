# frozen_string_literal: true

require 'spec_helper'

describe LiberaService do
  let(:work) { FactoryBot.create_for_repository(:work) }
  let(:blob) { FactoryBot.create_for_repository(:blob, :pdf) }
  let(:libera_service) { described_class.new({ work_id: work.id, blob_id: blob.id }) }

  describe '#run' do
    it 'runs the libera gem against the blob and adds items to the work' do
      expect { libera_service.run }.to change { work.children.count }.from(0).to(1)
      expect(work.children[0].class).to eq(Stack)

      stack = work.children[0]
      expect(stack.children.count).to eq(1) # 1 page
      expect(stack.children[0].files.count).to eq(4) # 1 page == 1 image, 1 text, 1 tei file, 1 jp2 file
      # TODO: check that the member ids correspond with the blobs
    end
  end
end
