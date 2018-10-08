(function(){
  var HOST = "/media_upload/"

  addEventListener("trix-attachment-remove", function(event) {
    console.log(11)
    console.log(event.attachment)
    if (event.attachment.getURL()) {
      console.log(22)
      removeAttachment(event.attachment)
    }
  })

  function removeAttachment(attachment) {
    console.log(33)
    var grid_id = attachment.getURL().split("/")[2]
    var xhr = new XMLHttpRequest()

    xhr.open("DELETE", HOST, true)
    xhr.responseType = "json"

    var data = new FormData()
    data.append("grid_id", grid_id)
    xhr.send(data)
  }


  addEventListener("trix-attachment-add", function(event) {
    if (event.attachment.file) {
      uploadAttachment(event.attachment)
    }
  })

  function uploadAttachment(attachment) {
    var file = attachment.file
    var formData = createFormData(file)
    var xhr = new XMLHttpRequest()

    xhr.open("POST", HOST, true)
    xhr.responseType = "json"

    xhr.upload.addEventListener("progress", function(event) {
      var progress = event.loaded / event.total * 100
      attachment.setUploadProgress(progress)
    })

    xhr.addEventListener("load", function(event) {
      if (xhr.status == 201) {
        attachment.setAttributes({ url: xhr.response.url })
      }
    })

    xhr.send(formData)
  }

  function createFormData(file) {
    var data = new FormData()
    data.append("media", file)
    data.append("Content-Type", file.type)
    return data
  }
})();
