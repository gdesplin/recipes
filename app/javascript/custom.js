import Turbolinks from 'turbolinks';
import Lodash from 'lodash';
// Fix turbolinks get forms
document.addEventListener('turbolinks:load', function(event) {
  for (let form of document.querySelectorAll('form[method=get][data-remote=true]')) {
    form.addEventListener('ajax:beforeSend', function (event) {
      const detail = event.detail,
            xhr = detail[0], options = detail[1];

      Turbolinks.visit(options.url);
      event.preventDefault();
    });
  }
});

// Jquery Stuff
$(function() {
  $('[data-toggle="tooltip"]').tooltip();
});

$(function() {
  $('[data-toggle="popover"]').popover();
});
