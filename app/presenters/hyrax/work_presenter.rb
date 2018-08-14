# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    def export_as_xml
      "<TEI xmlns=\"http://www.tei-c.org/ns/1.0\"><teiHeader><fileDesc><titleStmt><title/></titleStmt><publicationStmt><p/></publicationStmt><sourceDesc><p/></sourceDesc></fileDesc></teiHeader><text><body><ab>And God said, Let there be light: and there was light.</ab></body></text></TEI>"
    end

    def xml_filename
      "derp.xml"
    end
  end
end
