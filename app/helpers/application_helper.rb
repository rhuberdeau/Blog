module ApplicationHelper
  def title
    base_title = "Robert's Quality Assurance tips and rails 3 tutorials"
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
  	base_keywords = "quality assurance, rails 3 tutorial, rails 3 tutorials, rails tutorial, ruby on rails tutorial, tutorials"
  	if @keywords.nil?
  		base_keywords
  	else
  		"#{@keywords}, #{base_keywords}"
  	end
  end
  
  def coderay(text)  
    text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do  
      CodeRay.scan($3, $2).div(:css => :class)  
    end  
  end 
end
