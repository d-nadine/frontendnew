window.setIframeHeight = (id) ->
  ifrm = document.getElementById(id)
  doc = (if ifrm.contentDocument then ifrm.contentDocument else ifrm.contentWindow.document)
  ifrm.style.visibility = "hidden"
  ifrm.style.height = "10px" # reset to minimal height ...
  # IE opt. for bing/msn needs a bit added or scrollbar appears
  ifrm.style.height = getDocHeight(doc) + 4 + "px"
  ifrm.style.visibility = "visible"

window.getDocHeight = (doc) ->
  doc = doc or document
  body = doc.body
  html = doc.documentElement
  height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)
  height

Ember.Handlebars.registerBoundHelper 'htmlBodyFormatter', (email, options) ->
  if !email.get('message')?.length && !email.get('html')?.length
    $('#email-body-iframe').remove()
    return new Handlebars.SafeString("<p>(No Message)</p>")

  if email.get('html')?.length
    text = email.get('html')
    text = text.replace(/(href=")x-msg:\/\/([^"]+)\//ig, '$1#$2')
  else
    text = email.get('message').replace(/\n/g, '<br />')
    re = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    text = text.replace(/<img[^>]*>/g,"")


  text = text.replace(re,"<a href='$1' target='_new'>$1</a>")

  Ember.run.next =>
    $('#email-body-iframe').remove()
    $('.iframe-container').append """
      <iframe id="email-body-iframe" style="width:100%"></iframe>
    """
    $('#email-body-iframe')[0].contentWindow.document.write text
    setIframeHeight 'email-body-iframe'
  return ""
