// Scrapes

(function($) {
  $(document).ready(function() {

    var TOGGLE_SPEED = 500;

    $('.scrape-data').hide();

    $('.scrape-data-toggle').click(function(e){
      e.preventDefault();

      var isHidden = $(this).attr('data-hidden') == 'true';
      var scrapeId = $(this).attr('data-scrape-id');
      var scrapeData = $('#scrape-data-' + scrapeId);
      var toggleText = (!isHidden) ? 'Show Data' : 'Hide Data';

      console.log(isHidden, !isHidden, scrapeId, scrapeData);

      if (isHidden) {
        scrapeData.show(TOGGLE_SPEED);
      } else {
        scrapeData.hide(TOGGLE_SPEED);
      }

      $(this).attr('data-hidden', !isHidden);
      $(this).text(toggleText);

      return false;
    });

  });
})(jQuery);

