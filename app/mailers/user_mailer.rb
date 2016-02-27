class UserMailer < ApplicationMailer
  default from: "adventclub94404@gmail.com"

  def signup_confirmation
    @greeting = "Hi"

    mail to: "to@example.org", subject: "Sign Up Confirmation"
  end
end
