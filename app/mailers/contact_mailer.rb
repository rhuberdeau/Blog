class ContactMailer < ApplicationMailer
  def new_contact(contact)
    @contact = contact
    mail(to: ENV['MY_EMAIL'], subject: 'Someone is trying to contact me')
  end
end
