Radium.ContentEditableBehaviour = Ember.Mixin.create
  setEndOfContentEditble: ->
    @$().setEndOfContentEditble()

  insertLineBreak: ->
    selection = window.getSelection()
    range = selection.getRangeAt(0)
    br = document.createElement('br')
    textNode = document.createTextNode('\u00a0')
    range.deleteContents()
    range.insertNode br
    range.collapse false
    range.insertNode textNode
    range.selectNodeContents textNode
    selection.removeAllRanges()
    selection.addRange range
    Ember.run.next =>
      @setEndOfContentEditble()
