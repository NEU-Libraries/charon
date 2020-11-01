# frozen_string_literal: true

class TeiService
  def initialize(params)
    @stack = Stack.find(params[:stack_id])
    @page_list = make_page_list

    Libera.configuration.working_dir = Rails.root.join('tmp').to_s + "/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
    @parser = Libera::Parser.new
    @parser.mk_working_dir
  end

  def run
    @parser.generate_tei(@page_list)
    @stack.tei = File.open("#{Libera.configuration.working_dir}/tei.xml").read
    Valkyrie.config.metadata_adapter.persister.save(resource: @stack)
  end

  private

    def make_page_list
      page_list = {}
      pages = @stack.pages
      pages.each do |p|
        page_list[p.png.original_filename] = p.text
        # TODO: p.png.original_filename needs to be turned into a URL
      end
      page_list
    end
end
