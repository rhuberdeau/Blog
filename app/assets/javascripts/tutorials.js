jQuery(document).ready(function(){
  var currentPosition = 0;
  var slideWidth = 560;
  var slides = jQuery('.slide');
  var numberOfSlides = slides.length;

  // Remove scrollbar in JS
  jQuery('#slidesContainer').css('overflow', 'hidden');

  // Wrap all .slides with #slideInner div
  slides
  .wrapAll('<div id="slideInner"></div>')
  // Float left to display horizontally, readjust .slides width
  .css({
    'float' : 'left',
    'width' : slideWidth
  });

  // Set #slideInner width equal to total width of all slides
  jQuery('#slideInner').css('width', slideWidth * numberOfSlides);

  // Insert left and right arrow controls in the DOM
  jQuery('#slideshownav')
    .prepend('<span class="control" id="leftControl">Move left</span>')
    .append('<span class="control" id="rightControl">Move right</span>');

  // Hide left arrow control on first load
  manageControls(currentPosition);

  // Create event listeners for .controls clicks
  jQuery('.control')
    .bind('click', function(){
    // Determine new position
      currentPosition = (jQuery(this).attr('id')=='rightControl')
    ? currentPosition+1 : currentPosition-1;

      // Hide / show controls
      manageControls(currentPosition);
      // Move slideInner using margin-left
      jQuery('#slideInner').animate({
        'marginLeft' : slideWidth*(-currentPosition)
      });
    });

  // manageControls: Hides and shows controls depending on currentPosition
  function manageControls(position){
    // Hide left arrow if position is first slide
    if(position==0){ jQuery('#leftControl').hide() }
    else{ jQuery('#leftControl').show() }
    // Hide right arrow if position is last slide
    if(position==numberOfSlides-1){ jQuery('#rightControl').hide() }
    else{ jQuery('#rightControl').show() }
    }
  });