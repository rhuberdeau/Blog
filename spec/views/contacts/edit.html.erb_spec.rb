require 'spec_helper'

describe "contacts/edit" do
  before(:each) do
    @contact = assign(:contact, stub_model(Contact,
      :name => "MyString",
      :email_address => "MyString",
      :phone_number => "MyString",
      :message => "MyText"
    ))
  end

  it "renders the edit contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contact_path(@contact), "post" do
      assert_select "input#contact_name[name=?]", "contact[name]"
      assert_select "input#contact_email_address[name=?]", "contact[email_address]"
      assert_select "input#contact_phone_number[name=?]", "contact[phone_number]"
      assert_select "textarea#contact_message[name=?]", "contact[message]"
    end
  end
end
