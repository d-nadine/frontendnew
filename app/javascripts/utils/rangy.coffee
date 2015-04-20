Radium.rangy =
  getSelection:  ->
    window.getSelection()

  getRange: ->
    @getSelection().getRangeAt(0)