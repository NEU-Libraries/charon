# frozen_string_literal: true

module InterfaceHelper
  def create_interfaces
    # Create interfaces
    Minerva::Interface.create(title: 'upload', code_point: 'generic_uploads#new')
    Minerva::Interface.create(title: 'transcribe', code_point: 'tasks#transcribe')
    Minerva::Interface.create(title: 'encode', code_point: 'tasks#encode')
    Minerva::Interface.create(title: 'catalog', code_point: 'tasks#catalog')
    Minerva::Interface.create(title: 'review', code_point: 'tasks#review')
    Minerva::Interface.create(title: 'publish', code_point: 'tasks#publish')
  end
end
