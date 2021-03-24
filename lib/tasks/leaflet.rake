# frozen_string_literal: true

namespace :leaflet do
  desc 'Copies binary assets to public for leaflet draw'
  task copy_images: :environment do
    FileUtils.cp_r 'node_modules/leaflet-draw/dist/images', 'public/assets'
  end
end
