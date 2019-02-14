class ApplicationController < ActionController::Base
  include Blacklight::Controller
  layout :determine_layout
end
