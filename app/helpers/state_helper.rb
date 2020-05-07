# frozen_string_literal: true

module StateHelper
  def claim_path(state)
    return if state.interface_id.blank?

    path_array = Interface.find(state.interface_id).code_point.split('#')
    url_for(controller: path_array[0],
            action: path_array[1],
            id: Work.find(
              Minerva::Work.find(state.work_id).auid
            ).noid)
  end
end
