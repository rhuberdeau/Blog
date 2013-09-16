module ApplicationHelper
  def full_title(page_title)
    base_title = "Robert Huberdeau"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
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
  
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
end
