# frozen_string_literal: true

class State < Minerva::State
  include Rails.application.routes.url_helpers

  # TODO: move claim_path out of the model and into a helper
  def claim_path
    if interface_id.present?
      path_array = Interface.find(interface_id).code_point.split('#')
      return url_for(controller: path_array[0], action: path_array[1], id: work.noid)
    end
  end

  private

    def work
      Work.find(Minerva::Work.find(work_id).auid)
    end
end
