#
#*   Sir Trevor Uploader
#*   Generic Upload implementation that can be extended for blocks
#
#*   modified by @pedroaxl to upload directly to S3

SirTrevor.fileUploader = (block, file, success, error) ->
  SirTrevor.EventBus.trigger "onUploadStart"
  uid = [block.blockID, (new Date()).getTime(), "raw"].join("-")

  block.resetMessages()
  callbackSuccess = (data, textStatus, jqXHR) ->
    SirTrevor.log "Upload callback called"
    SirTrevor.EventBus.trigger "onUploadStop"
    # once the PUT response from Amazon comes empty, I had to change this line to include the url
    _.bind(success, block) {file: { large: { url: this.url }, url: this.url } }  if not _.isUndefined(success) and _.isFunction(success)

  callbackError = (jqXHR, status, errorThrown) ->
    SirTrevor.log "Upload callback error called"
    SirTrevor.EventBus.trigger "onUploadStop"
    _.bind(error, block) status  if not _.isUndefined(error) and _.isFunction(error)

  $.ajax(
    url: '/blog/sign_s3'
    #   before sending to Amazon using PUT, it makes a req to get the signature that will allow the upload
    data: {
      file_name: file.name
      file_type: file.type
    }
    type: 'GET'
    error: callbackError
    success: (data, textStatus, jqXHR) ->
      xhr = $.ajax(
        url: data.url
        contentType: file.type
        crossDomain: true
        data: file
        processData: false
        headers: {
          'Content-MD5': file.md5
          'Authorization': data.signature
          'x-amz-date': data.date
          'x-amz-acl': 'public-read' # set the public read permission on the uploaded file
        }
        type: "PUT"
        success: callbackSuccess
      )
      block.addQueuedItem uid, xhr
      xhr.done(callbackSuccess).fail(callbackError).always _.bind(block.removeQueuedItem, block, uid)
      xhr
  )
