$(document).ready(function() {
  id = $('.related_articles').attr('data-url');
  $(".related_articles").click(function(){
  	$.getJSON('/related-articles/' + id, function(data) {
  	  if (data.length > 0) {
  	  	$(".related_articles").css('background-color', '#fff');
  	    $('.related_articles').html("<h2>The complete series</h2>")
        data.forEach(appendElement)
      }
    });
  });
});

function appendElement(elem) {
  $('.related_articles').append("<a href=\"/articles/" + elem.cached_slug + "\">" + elem.title + "</a>" + "<br />");
};	

$(document).ready(function() {
  s_id = $('.related_articles').attr('id');
  if (s_id == 'sequence_1') {
    $('.related_articles').html("<p>Click here to view the complete series</p>")
  }
});