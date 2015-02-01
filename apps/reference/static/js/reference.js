document.addEventListener("DOMContentLoaded", function(event) {

  function hideCode() {
    var codes = Dom.find('div.highlight')
    for(var i = 0; i < codes.length; i++) {
      var code = codes.item(i);
      if(!Dom.hasClass(code, 'gherkin')) {
        Dom.addClass(code, 'hidden');
      }
    }
  }

  var links = Dom.find('#language > a')
  Dom.addListener(links, Dom.Event.ON_CLICK, function (event) {
    hideCode();
    var codes = Dom.find('div.highlight.' + event.target.dataset.language);
    Dom.removeClass(codes, 'hidden');
  });

  hideCode();

});
