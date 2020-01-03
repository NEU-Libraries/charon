# frozen_string_literal: true

class WorkChangeSet < Valkyrie::ChangeSet
  property :title
  property :a_member_of
  property :mods_xml
  validates :title, presence: true

  def sync!(options)
    begin
      mods_title = Nokogiri::XML(mods_xml).at_xpath('//mods:titleInfo/mods:title').text
      self.title = mods_title if mods_title.present?
    rescue Nokogiri::XML::XPath::SyntaxError
      Rails.logger.error('No title found')
      # TODO: actually do something when we no longer have a placeholder empty mods - need validation
    end
    super
  end
end
