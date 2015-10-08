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

  getCaretPosition: (range, node) ->
    treeWalker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT, ((n) ->
      nodeRange = document.createRange()
      nodeRange.selectNode n
      if nodeRange.compareBoundaryPoints(Range.END_TO_END, range) < 1
        NodeFilter.FILTER_ACCEPT
      NodeFilter.FILTER_REJECT
    ), false)
    charCount = 0
    while treeWalker.nextNode()
      charCount += treeWalker.currentNode.length
    if range.startContainer.nodeType == 3
      charCount += range.startOffset
    charCount

  setCaretPos:(el, sPos) ->
    charIndex = 0
    range = document.createRange()
    range.setStart el, 0
    range.collapse true
    nodeStack = [ el ]
    node = undefined
    foundStart = false
    stop = false
    while !stop and (node = nodeStack.pop())
      if node.nodeType == 3
        nextCharIndex = charIndex + node.length
        if !foundStart and sPos >= charIndex and sPos <= nextCharIndex
          range.setStart node, sPos - charIndex
          foundStart = true
        if foundStart and sPos >= charIndex and sPos <= nextCharIndex
          range.setEnd node, sPos - charIndex
          stop = true
        charIndex = nextCharIndex
      else
        i = node.childNodes.length
        while i--
          nodeStack.push node.childNodes[i]
    selection = window.getSelection()
    selection.removeAllRanges()
    selection.addRange range
    return
