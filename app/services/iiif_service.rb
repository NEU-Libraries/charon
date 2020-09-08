# frozen_string_literal: true

class IiifService
  include MimeHelper

  def initialize(params)
    @file_set = FileSet.find(params[:file_set_id])
  end

  def run
    seed = {
      '@id' => 'http://example.com/manifest',
      'label' => 'My Manifest'
    }

    manifest = IIIF::Presentation::Manifest.new(seed)
    sequence = generate_sequence

    populate_sequence(sequence)

    manifest.sequences << sequence

    manifest.to_json(pretty: true)
  end

  private

    def populate_sequence(sequence)
      # canvas loop
      canvases = []
      @file_set.files.each_with_index do |blob, i|
        # need to check if blob is image-y
        next unless determine_mime(blob.file_path).image?

        img = Magick::Image.ping(blob.file_path).first
        canvas = generate_canvas(img, i)
        canvases.append(canvas)
      end
      sequence['canvases'] = canvases
    end

    def generate_sequence
      sequence = IIIF::Presentation::Sequence.new
      sequence['@id'] = 'http://' + SecureRandom.uuid
      sequence['@type'] = 'sc:Sequence'
      sequence['label'] = 'Current order'
      sequence['viewingDirection'] = 'left-to-right'
      sequence
    end

    def generate_canvas(img, index)
      canvas = IIIF::Presentation::Canvas.new
      canvas_id = 'http://' + SecureRandom.uuid
      canvas['@id'] = canvas_id
      canvas['width'] = img.columns
      canvas['height'] = img.rows
      canvas['label'] = "Image #{index + 1}"

      image = generate_image(img, canvas_id)

      canvas['images'] = [image]
      canvas
    end

    def generate_image(img, canvas_id)
      image = IIIF::Presentation::Resource.new('@id' => 'http://' + SecureRandom.uuid)
      image['@type'] = 'oa:Annotation'
      image['motivation'] = 'sc:painting'
      image['on'] = canvas_id
      image['resource'] = generate_resource(img)
      image
    end

    def generate_resource(img)
      resource = IIIF::Presentation::Resource.new('@id' =>
        "http://localhost:8182/iiif/2/#{img.filename.split('/').last.split('.').first}/full/full/0/default.jpg")
      resource['@type'] = 'dctypes:Image'
      resource['format'] = 'image/jpeg'
      resource['width'] = img.columns
      resource['height'] = img.rows
      resource
    end
end
