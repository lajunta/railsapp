require("@rails/ujs").start()
require("bootstrap/dist/js/bootstrap")
require("jquery")
require("trix")
require("./trix-ajax")
require("./z-trix.coffee")
import "../stylesheets/application"

const Trix = require('trix')
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

//= require_tree .
//
Trix.config.attachments.preview.caption = { name: false, size: false }


$(document).keydown(function(e){
  if(e.keyCode==46 && e.ctrlKey){
    $(".operator").toggle();
  }
});

$(document).ready(function(){

  $(".loginForm").submit(function(event){
    if($("input.code").val()==""){alert("请填写验证码");return false;};
    if($("input.login").val()==""){alert("登录名不能为空");return false;};
    if($("input.password").val()==""){alert("密码不能为空");return false;};
  }); 

  $("a.rucaptcha-image-box").click(function(e){
    e.preventDefault();
    btn = $(e.currentTarget);
    img = btn.find('img:first');
    currentSrc = img.attr('src');
    img.attr('src', currentSrc.split('?')[0] + '?' + (new Date()).getTime());
    return false;
  }); 

});

require("turbolinks").start()
