require 'spec_helper'

describe "contacts/new" do
  before(:each) do
    assign(:contact, stub_model(Contact,
      :name => "MyString",
      :email_address => "MyString",
      :phone_number => "MyString",
      :message => "MyText"
    ).as_new_record)
  end

  it "renders new contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contacts_path, "post" do
      assert_select "input#contact_name[name=?]", "contact[name]"
      assert_select "input#contact_email_address[name=?]", "contact[email_address]"
      assert_select "input#contact_phone_number[name=?]", "contact[phone_number]"
      assert_select "textarea#contact_message[name=?]", "contact[message]"
    end
  end
end
