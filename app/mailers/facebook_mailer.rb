class FacebookMailer < ActionMailer::Base
  default from: "app@kickmeup.com"

  def invite_friends(user, recipients)
    @user = user

    mail to: recipients, subject: "#{@user.name} has invited you to use Kickmeup!"
  end
end
