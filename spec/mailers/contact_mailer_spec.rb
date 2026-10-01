describe ContactMailer do
  it "sends the message to the configured address" do
    contact = Contact.new(name: "Ann", email_address: "ann@example.com", message: "Hello there")
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("MY_EMAIL").and_return("me@example.com")

    mail = ContactMailer.new_contact(contact)

    expect(mail.to).to eq([ "me@example.com" ])
    expect(mail.body.encoded).to include("Hello there")
  end
end
