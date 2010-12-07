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
  
  
end
