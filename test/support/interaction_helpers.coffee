window.click = (object) ->
  if object.hasOwnProperty 'click'
    object.click()
  else
    $F(object).click()

window.fillIn = (selector, text) ->
  # keyup with any char to trigger bindings sync
  event = jQuery.Event("keyup")
  event.keyCode = 46
  if $F(selector).length == 0
    throw "Could not find #{selector}"
  $F(selector).val(text).trigger(event)

window.enterNewLine = (selector) ->
  event = jQuery.Event("keypress")
  event.keyCode = 13
  if $F(selector).length == 0
    throw "Could not find #{selector}"
  $F(selector).trigger(event)
