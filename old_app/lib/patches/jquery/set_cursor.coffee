$.fn.setCursorPosition = (pos) ->
  @each ->
    v = $(this).val()
    $(this).focus().val('').val v
    return this

$.fn.restoreCursor = (pos )->
  element = $(this).get(0)
  range = document.createRange()
  range.setStart(element.firstChild, pos)
  range.setEnd(element.firstChild, pos)
  selection = window.getSelection()
  selection.removeAllRanges()
  selection.addRange(range)

$.fn.setEndOfContentEditble = ->
  range = document.createRange()
  range.selectNodeContents(this.get(0))
  range.collapse(false)
  selection = window.getSelection()
  selection.removeAllRanges()
  selection.addRange(range)

$.fn.selectText = ->
  doc = document
  element = @[0]

  if doc.body.createTextRange
    range = document.body.createTextRange()
    range.moveToElementText element
    range.select()
  else if window.getSelection
    selection = window.getSelection()
    range = document.createRange()
    range.selectNodeContents element
    selection.removeAllRanges()
    selection.addRange range
