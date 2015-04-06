Radium.ContentEditableBehaviour = Ember.Mixin.create
  setEndOfContentEditble: ->
    range = document.createRange()
    range.selectNodeContents(@$().get(0))
    range.collapse(false)
    selection = window.getSelection()
    selection.removeAllRanges()
    selection.addRange(range);
