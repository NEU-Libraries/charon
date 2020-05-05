# frozen_string_literal: true

class State < Minerva::State
  include Rails.application.routes.url_helpers

  def claim_path
    path_array = Interface.find(interface_id).code_point.split('#')
    url_for(controller: path_array[0], action: path_array[1], id: work.noid)
  end

  private

    def work
      Work.find(Minerva::Work.find(work_id).auid)
    end
end
