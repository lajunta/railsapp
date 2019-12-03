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
Trix.config.attachments.preview.caption = {
  name: false,
  size: false
}


var filterType = /^(?:image\/bmp|image\/cis\-cod|image\/gif|image\/ief|image\/jpeg|image\/jpeg|image\/jpeg|image\/pipeg|image\/png|image\/svg\+xml|image\/tiff|image\/x\-cmu\-raster|image\/x\-cmx|image\/x\-icon|image\/x\-portable\-anymap|image\/x\-portable\-bitmap|image\/x\-portable\-graymap|image\/x\-portable\-pixmap|image\/x\-rgb|image\/x\-xbitmap|image\/x\-xpixmap|image\/x\-xwindowdump)$/i;

function handleImg(img) {
  var fileReader = new FileReader();
  fileReader.readAsDataURL(img);
  fileReader.onload = function (event) {
    var image = new Image();
    image.src = event.target.result;
    image.onload = function () {
      var newWidth = image.width
      var newHeight = image.height
      var fixedValue = 960
      var fixedValue2 = 768

      if (image.width > fixedValue && image.width > image.height) {
        newWidth = fixedValue;
        scaleFactor = newWidth / image.width;
        newHeight = image.height * scaleFactor;
      }

      if (image.height > fixedValue2 && image.height > image.width) {
        newHeight = fixedValue2;
        scaleFactor = newHeight / image.height;
        newWidth = image.width * scaleFactor;
      }

      const elem = document.createElement('canvas');
      elem.width = newWidth
      elem.height = newHeight

      const ctx = elem.getContext('2d');
      ctx.drawImage(image, 0, 0, newWidth, newHeight);

      var element = document.querySelector("trix-editor");
      var media_file = document.querySelector(".media_file")

      //var bob = ctx.canvas.toBlob((blob)=>{ },"image/jpeg",0.8);
      const promise1 = new Promise(resolve => {
        ctx.canvas.toBlob((blob) => {
          let file = new File([blob], "temp.jpg", {
            "type": "image/jpeg"
          })
          resolve(file)
        }, "image/jpeg", 0.8);
      });
      promise1.then(function (imgblob) {
        element.editor.insertFile(imgblob);
        media_file.value = null;
      })
    }
  };
}


$(document).keydown(function (e) {
  if (e.keyCode == 46 && e.ctrlKey) {
    $(".operator").toggle();
  }
});

$(document).ready(function () {

  $(".loginForm").submit(function (event) {
    if ($("input.code").val() == "") {
      alert("请填写验证码");
      return false;
    };
    if ($("input.login").val() == "") {
      alert("登录名不能为空");
      return false;
    };
    if ($("input.password").val() == "") {
      alert("密码不能为空");
      return false;
    };
  });

  $("a.rucaptcha-image-box").click(function (e) {
    e.preventDefault();
    btn = $(e.currentTarget);
    img = btn.find('img:first');
    currentSrc = img.attr('src');
    img.attr('src', currentSrc.split('?')[0] + '?' + (new Date()).getTime());
    return false;
  });


  var media_file = $("input[name='media_file']")
  $(".trix-button--icon-attach").on("click", function () {
    media_file.click()
  })

  media_file.on("change", function (event) {
    //if(event.target.name=="media_file"){
    var img = event.target.files[0]
    if (!filterType.test(img.type)) {
      alert("请选择图片文件.");
      return;
    }
    handleImg(img)
    // var element = document.querySelector("trix-editor");
    // element.editor.insertFile(img);
    // media_file.val(null)
    //} 
  })


});

require("turbolinks").start()