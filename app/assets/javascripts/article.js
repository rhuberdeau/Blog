$(document).ready(function() {
  l = window.location.pathname.split('/')[2].toLowerCase();
  $.getJSON('/related-articles/' + l, function(data) {
  	if (data.length > 0) {
  	  $('#related_articles').html("<h2>The complete series</h2>")
      data.forEach(appendElement)
    }
  });
});

function appendElement(elem) {
  $('#related_articles').append("<a href=\"/articles/" + elem.cached_slug + "\">" + elem.title + "</a>" + "<br />");
};