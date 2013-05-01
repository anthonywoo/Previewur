class ImageMailer < ActionMailer::Base
  default from: "from@example.com"

  def image_ready_email(image)
    user = image.user
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end

end
