# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@charon.library.northeastern.edu'
  layout 'mailer'
end
