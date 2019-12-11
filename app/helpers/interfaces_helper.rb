# frozen_string_literal: true

module InterfacesHelper
  def upload_interface
    Minerva::Interface.find_by(title: "upload")
  end

  def catalog_interface
    Minerva::Interface.find_by(title: "catalog")
  end
end
