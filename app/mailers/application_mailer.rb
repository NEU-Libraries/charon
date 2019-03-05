# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@charon.library.northeastern.edu'
  layout 'mailer'
end
