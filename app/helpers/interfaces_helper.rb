# frozen_string_literal: true

module InterfacesHelper
  def upload_interface
    Minerva::Interface.find_by(title: "upload")
  end

  def interface_past_tense(interface)
    I18n.t "charon.interface.#{interface}.past_tense"
  end

  def interface_present_tense(interface)
    I18n.t "charon.interface.#{interface}.present_tense"
  end
end
