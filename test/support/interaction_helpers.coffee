window.fillIn = (selector, text) ->
  # keyup with any char to trigger bindings sync
  event = jQuery.Event("keyup")
  event.keyCode = 46
  if $(selector).length == 0
    throw "Could not find #{selector}"
  $(selector).val(text).trigger(event)

window.enterNewLine = (selector) ->
  event = jQuery.Event("keypress")
  event.keyCode = 13
  if $(selector).length == 0
    throw "Could not find #{selector}"
  $(selector).trigger(event)
