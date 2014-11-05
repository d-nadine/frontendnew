$.fn.setCursorPosition = (pos) ->
  if $(this).get(0).setSelectionRange
    $(this).get(0).setSelectionRange(pos, pos)
  else if ($(this).get(0).createTextRange)
    range = $(this).get(0).createTextRange()
    range.collapse(true)
    range.moveEnd('character', pos)
    range.moveStart('character', pos)
    range.select()


$.fn.restoreCursor = (pos )->
  element = $(this).get(0)
  range = document.createRange()
  range.setStart(element.firstChild, pos)
  range.setEnd(element.firstChild, pos)
  selection = window.getSelection()
  selection.removeAllRanges()
  selection.addRange(range)
