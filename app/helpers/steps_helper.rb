module StepsHelper
	
  def next_link
  	@steps = @tutorial.steps
  	@current_position = @step
  	@current_position = @steps.index(@current_position)
  	@last = @steps.last
  	@last = @steps.index(@last)
  	if @current_position == @last
  	  @next_link = @steps.first
  	else
  	  @current_position = @step
  	  @next = @steps.index(@current_position)
  	  @next += 1
  	  @next_link = @steps[@next]
  	end
  end
  
  def previous_link
  	@steps = @tutorial.steps
  	@current_position = @step
  	@current_position = @steps.index(@current_position)
  	@first = @steps.first
  	@first = @steps.index(@first)
  	if @current_position == @first
  	  @next_link = @steps.last
  	else
  	  @current_position = @step
  	  @next = @steps.index(@current_position)
  	  @next -= 1
  	  @next_link = @steps[@next]
  	end
  end
end
