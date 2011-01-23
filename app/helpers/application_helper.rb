require 'recaptcha'

module ApplicationHelper
  
  
  def title
    base_title = "Robert's Rails 3 tips and tutorials"
    if @title.nil?
      base_title
    else
      "#{@title}"
    end
  end
  
  def metadescription
  	base_content = "A collection of tutorials and tips to help a new Rails developer"
  	if @content.nil?
  		base_content
  	else
  		"#{@content}"
  	end
  end
  
  def keywords
  	base_keywords = "rails 3 tutorial, rails 3 tutorials, rails tutorial, ruby on rails tutorial, tutorials"
  	if @keywords.nil?
  		base_keywords
  	else
  		"#{@keywords}, #{base_keywords}"
  	end
  end 
end
