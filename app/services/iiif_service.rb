# frozen_string_literal: true

class IiifService
  include ApplicationHelper
  include MimeHelper

  def initialize(params)
    @single_blob = Blob.find(params[:blob_id]) if params[:blob_id].present?
    @stack = Stack.find(params[:stack_id]) if params[:stack_id].present?
  end

  def run
    seed = {
      '@id' => 'http://example.com/manifest',
      'label' => 'My Manifest'
    }

    manifest = IIIF::Presentation::Manifest.new(seed)
    sequence = generate_sequence
    single_or_multi(sequence)
    manifest.sequences << sequence

    manifest.to_json(pretty: true)
  end

  private

    def img
      Magick::Image.ping(@blob.file_path).first
    end

    def single_or_multi(sequence)
      if @single_blob.nil?
        populate_sequence(sequence)
      else
        @blob = @single_blob
        canvas = generate_canvas(0)
        sequence['canvases'] = [canvas]
      end
    end

    def populate_sequence(sequence)
      # canvas loop
      canvases = []
      @stack.children.each_with_index do |fs, i|
        fs.files.each do |b|
          @blob = b
          # need to check if blob is image-y
          next unless determine_mime(@blob.file_path).image? && @blob.extension.casecmp?('jp2')

          canvas = generate_canvas(i)
          canvases.append(canvas)
        end
      end
      sequence['canvases'] = canvases
    end

    def generate_sequence
      sequence = IIIF::Presentation::Sequence.new
      sequence['@id'] = "http://#{SecureRandom.uuid}"
      sequence['@type'] = 'sc:Sequence'
      sequence['label'] = 'Current order'
      sequence['viewingDirection'] = 'left-to-right'
      sequence
    end

    def generate_canvas(index)
      canvas = IIIF::Presentation::Canvas.new
      canvas_id = "http://#{SecureRandom.uuid}"
      canvas['@id'] = canvas_id
      canvas['width'] = img.columns
      canvas['height'] = img.rows
      canvas['label'] = "Image #{index + 1}"

      image = generate_image(canvas_id)

      canvas['images'] = [image]
      canvas
    end

    def generate_image(canvas_id)
      image = IIIF::Presentation::Resource.new('@id' => "http://#{SecureRandom.uuid}")
      image['@type'] = 'oa:Annotation'
      image['motivation'] = 'sc:painting'
      image['on'] = canvas_id
      image['resource'] = generate_resource
      image
    end

    def generate_resource
      resource = IIIF::Presentation::Resource.new('@id' =>
        "#{iiif_url}/2/#{@blob.noid}/full/full/0/default.jpg")
      resource['@type'] = 'dctypes:Image'
      resource['format'] = 'image/jpeg'
      resource['width'] = img.columns
      resource['height'] = img.rows
      resource
    end
end
