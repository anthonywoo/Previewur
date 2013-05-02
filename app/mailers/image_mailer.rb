class ImageMailer < ActionMailer::Base
  default from: "from@example.com"

  def image_ready_email(image)
    @image = image
    user = image.user
    mail(to: user.email, subject: 'Your Animated GIF is ready')
  end

end
