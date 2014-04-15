window.setIframeHeight = (id) ->
  ifrm = document.getElementById(id)
  doc = (if ifrm.contentDocument then ifrm.contentDocument else ifrm.contentWindow.document)
  ifrm.style.visibility = "hidden"
  ifrm.style.height = "10px"
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
    text = email.get('message')
    try
      $(text)[0]
    catch
      text = text.replace(/\n/g, '<br />')

  text = text.replace(/<(a)([^>]+)>/ig,"<$1 target=\"_blank\"  $2>")

  Ember.run.next =>
    $('#email-body-iframe').remove()
    $('.iframe-container').append """
      <iframe id="email-body-iframe" src="#?linkTarget=_blank"></iframe>
    """

    $('#email-body-iframe')[0].contentWindow.document.write text
    setIframeHeight 'email-body-iframe'

  return ""
