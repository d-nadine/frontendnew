$.fn.setCursorPosition = (pos) ->
  if $(this).get(0).setSelectionRange
    $(this).get(0).setSelectionRange(pos, pos)
  else if ($(this).get(0).createTextRange)
    range = $(this).get(0).createTextRange()
    range.collapse(true)
    range.moveEnd('character', pos)
    range.moveStart('character', pos)
    range.select()
