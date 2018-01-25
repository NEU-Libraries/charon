class StagingTestMailer < ApplicationMailer
  def test_email
    mail(
      from: "notifications@charon.library.northeastern.edu",
      to: "dgcliff@northeastern.edu",
      subject: "Test mail",
      body: "Test mail body"
    )
  end
end
