Radium.ContentEditableBehaviour = Ember.Mixin.create
  setEndOfContentEditble: (node) ->
    ele = if node
            node
          else
            @$()

    ele.setEndOfContentEditble()

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

  insertHtml: (html) ->
    sel = undefined
    range = undefined
    if window.getSelection
      sel = window.getSelection()
      if sel.getRangeAt and sel.rangeCount
        range = sel.getRangeAt(0)
        range.deleteContents()
        el = document.createElement('div')
        el.innerHTML = html
        frag = document.createDocumentFragment()
        node = undefined
        lastNode = undefined
        while node = el.firstChild
          lastNode = frag.appendChild(node)
        range.insertNode frag

        if lastNode
          range = range.cloneRange()
          range.setStartAfter lastNode
          range.collapse true
          sel.removeAllRanges()
          sel.addRange range
    else if document.selection and document.selection.type != 'Control'
      document.selection.createRange().pasteHTML html
