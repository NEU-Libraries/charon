class PagesController < ApplicationController
  layout "application"
  def home
    @git_log = `cd #{Rails.root} && git log -n 20 --decorate --oneline`
  end
end
