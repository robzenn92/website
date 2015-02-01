document.addEventListener("DOMContentLoaded", function(event) {

  function showLanguage(language) {
    // Hide all languages
    Dom.addClass(Dom.find('div.toggle'), 'hidden');

    // Show the language we want
    Dom.removeClass(Dom.find('div.toggle.' + language), 'hidden');
  }

  showLanguage('ruby');

  // Add listeners for language links
  Dom.addListener(Dom.find('#language > a'), Dom.Event.ON_CLICK, function (event) {
    showLanguage(event.target.dataset.language);
  });

});
