require 'spec_helper'

describe "Static pages" do

  describe "About page" do

    it "should have the content 'About'" do
      visit '/about'
      page.should have_content('About')
    end
  end

  describe  "Contact page" do
  	
    it "should have content 'Contact'" do
      visit '/contact'
	    page.should have_content('To contact me please send an email to rhuberdeau at gmail dot com.')
	  end
  end
end