class ContactMailer < ApplicationMailer
  def notify(name:, email:, subject:, message:)
    @name = name
    @email = email
    @subject = subject
    @message = message

    mail(
      to: "farukpolat2309@gmail.com",
      reply_to: email,
      subject: subject
    )
  end
end
