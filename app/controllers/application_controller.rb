class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior
  layout :determine_layout
end
