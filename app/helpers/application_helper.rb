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
  	base_content = "A collection of tips and tutorials to help Rails developers"
  	if @content.nil?
  		base_content
  	else
  		"#{@content}"
  	end
  end
  
  def keywords
  	base_keywords = "software development, ruby on rails, quality assurance, ruby on rails tutorials"
  	if @keywords.nil?
  		base_keywords
  	else
  		"#{@keywords}"
  	end
  end

  def title
    base_title = "This is going to blow your mind"
    if @title.nil?
      base_title
    else
      "#{@title}"
    end
  end
  
  def coderay(text)  
    text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do  
      CodeRay.scan($3, $2).div(:css => :class)  
    end  
  end 
end
