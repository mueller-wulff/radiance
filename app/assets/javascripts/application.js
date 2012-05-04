//= require jquery
//= require jquery_ujs
//= require_self
//= require_directory .
//= require rails.validations
//

$(function() {
  $('[data-remote][data-replace]')
    .data('type', 'html')
    .live('ajax:success', function(event, data) {
      var $this = $(this);
      $($this.data('replace')).html(data);
      $this.trigger('ajax:replaced');
    });
});
