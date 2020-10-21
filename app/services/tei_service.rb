# frozen_string_literal: true

class TeiService
  def initialize(params)
    @stack = Stack.find(params[:stack_id])
    @page_list = params[:page_list]

    Libera.configuration.working_dir = Rails.root.join('tmp').to_s + "/libera-#{Time.now.to_f.to_s.gsub!('.', '')}"
    @parser = Libera::Parser.new
    @parser.mk_working_dir
  end

  def run
    @parser.generate_tei(@page_list)
    @stack.tei = File.open("#{Libera.configuration.working_dir}/tei.xml").read
    Valkyrie.config.metadata_adapter.persister.save(resource: @stack)
  end
end
