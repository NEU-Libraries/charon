# Generated via
#  `rails generate hyrax:work Work`

module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Work

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::WorkPresenter

    def additional_response_formats(format)
      format.xml do
          send_data(show_presenter.export_as_xml,
                    type: "text/xml",
                    filename: show_presenter.xml_filename)
      end
    end
  end
end
