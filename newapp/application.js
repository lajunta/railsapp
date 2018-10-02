//= require jquery3
//= require popper
//= require bootstrap
//= require jquery_ujs
//= require_tree .
$(document).ready(function(){

});

$(document).keydown(function(e){
  if(e.keyCode==46 && e.ctrlKey){
    $(".operator").toggle();
  }
});

//= require turbolinks
