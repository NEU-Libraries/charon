# frozen_string_literal: true

namespace :tinymce do
  desc 'Copies skin assets to public for tinymce'
  task copy_skins: :environment do
    FileUtils.cp_r 'node_modules/tinymce/skins', 'public/packs/js'
  end
end
