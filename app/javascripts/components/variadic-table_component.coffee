Radium.VariadicTableComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  actions:
    showMore: ->
      @sendAction 'showMore'
      return false

    sortTable: (prop, ascending) ->
      @sendAction 'sort', prop, ascending
      return false

  colSpan: Ember.computed 'columns.length', ->
    @get('columns.length') + 1

  atStartOrEnd: (el) ->
    atStart = false
    atEnd = false
    selRange = undefined
    testRange = undefined
    sel = window.getSelection()
    if sel.rangeCount
      selRange = sel.getRangeAt(0)
      testRange = selRange.cloneRange()
      testRange.selectNodeContents el
      testRange.setEnd selRange.startContainer, selRange.startOffset
      atStart = (testRange.toString() is "")
      testRange.selectNodeContents el
      testRange.setStart selRange.endContainer, selRange.endOffset
      atEnd = (testRange.toString() is "")
    atStart: atStart
    atEnd: atEnd

  keyDown: (e) ->
    current = $(e.target)
    return unless current.hasClass 'editable'

    navigatable = @atStartOrEnd(current.get(0))

    return unless [@TAB, @ARROW_UP, @ARROW_DOWN].contains(e.keyCode) || navigatable.atStart || navigatable.atEnd

    table = current.closest('table')
    isFixed = table.parent().hasClass 'fixed'

    other_table = if isFixed
                    $('.variable table')
                  else
                    $('.fixed table')

    row = current.parents('tr:first')
    rows = table.children().children('tr')
    rowIndex = rows.index(row)

    return if e.keyCode == @ARROW_UP && rowIndex == 1

    return if e.keyCode == @ARROW_DOWN && (rowIndex == (rows.length - 1))

    editables = row.find('td .editable')
    currentIndex = editables.index(current)

    navigateVertically = (indexFn) ->
      newIndex = indexFn(rowIndex)

      newRow = $(rows[newIndex])

      editables = newRow.find('td .editable')

      next = $(editables[currentIndex])

      next.trigger 'focus'

    if e.keyCode == @ARROW_DOWN
      return navigateVertically (x) -> x + 1

    if e.keyCode == @ARROW_UP
      return navigateVertically (x) -> x - 1

    otherTableJump = ->
      row = other_table.find("tr:nth-of-type(#{rowIndex})")

      editable = row.find('td .editable').first()
      return editable.trigger 'focus'

    if isFixed && e.keyCode == @TAB
      e.preventDefault()
      return otherTableJump()

    if navigatable.atEnd && isFixed && e.keyCode == @ARROW_RIGHT
      return otherTableJump()

    if navigatable.atStart && !isFixed && currentIndex == 0 && e.keyCode == @ARROW_LEFT
      return otherTableJump()

    navigateHorizontally = (indexFn) ->
      newIndex = indexFn(currentIndex)

      unless next = editables[newIndex]
        return

      next = $(next)

      next.trigger 'focus'

    if navigatable.atEnd && e.keyCode == @ARROW_RIGHT
      return navigateHorizontally (x) -> x + 1

    if navigatable.atStart && e.keyCode == @ARROW_LEFT
      return navigateHorizontally (x) -> x - 1
