# frozen_string_literal: true

class Interface < Minerva::Interface
  def past_tense
    I18n.t "charon.interface.#{title}.past_tense"
  end

  def present_tense(interface)
    I18n.t "charon.interface.#{title}.present_tense"
  end
end
