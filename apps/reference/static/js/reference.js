document.addEventListener("DOMContentLoaded", function(event) {

  function showLanguage(language) {
    // Hide all languages
    var codes = Dom.find('div.highlight')
    for(var i = 0; i < codes.length; i++) {
      var code = codes.item(i);
      if(!Dom.hasClass(code, 'gherkin')) {
        Dom.addClass(code, 'hidden');
      }
    }

    // Show the one we want
    codes = Dom.find('div.highlight.' + language);
    Dom.removeClass(codes, 'hidden');
  }

  showLanguage('ruby');

  // Add listeners for language links
  Dom.addListener(Dom.find('#language > a'), Dom.Event.ON_CLICK, function (event) {
    showLanguage(event.target.dataset.language);
  });

});
