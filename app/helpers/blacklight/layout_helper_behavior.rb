# frozen_string_literal: true

module Blacklight
  module LayoutHelperBehavior
    ##
    # Class used for specifying main layout container classes. Can be
    # overwritten to return 'container-fluid' for Bootstrap full-width layout
    # @return [String]
    def container_classes
      'container-lg'
    end
  end
end
