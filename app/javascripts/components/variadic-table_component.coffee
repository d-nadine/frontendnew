
Radium.VariadicTableComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  actions:
    showMore: ->
      @sendAction 'showMore'

      false

    sortTable: (prop, ascending) ->
      @sendAction 'sort', prop, ascending

      false

    toggleColumnSelection: ->
      @sendAction "toggleColumnSelection"

      false

  colSpan: Ember.computed 'columns.length', ->
    @get('columns.length') + 1

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    selector = ".next-task-component .dropdown-toggle, .assignto-picker-component .dropdown-toggle, .status-picker-component .dropdown-toggle, .change-liststatus-component .dropdown-toggle"

    clearMenus = ->
      $(selector).each ->
        $(this).parent().removeClass('open')

    @$().on "click.dropown.variadic", selector, (e) ->
      target = $(e.target)

      a = if target.hasClass('dropdown-toggle')
            target
          else
            target.parents('.dropdown-toggle:first')

      parent = target.parents('div:first')

      isActive = parent.hasClass('open')

      clearMenus()

      if !isActive
        parent.toggleClass('open')

      menu = parent.find('.dropdown-menu')

      return unless position = a.position()

      menu.css({top: position.top + 20, left: position.left})

      false

    $(document).on 'click.variadic.html.close.menus', clearMenus
    $('.right-table').on 'scroll.right', clearMenus

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$().off "click.dropown.variadic"
    $(document).off 'click.variadic.html.close.menus'
    $('.right-table').off 'scroll.right'

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

    focusElement = (el) ->
      el.attr 'contenteditable', "true"

      Ember.run.next ->
        el.trigger 'focus'

    navigateVertically = (indexFn) ->
      newIndex = indexFn(rowIndex)

      newRow = $(rows[newIndex])

      editables = newRow.find('td .editable')

      next = $(editables[currentIndex])

      focusElement(next)

    if e.keyCode == @ARROW_DOWN
      return navigateVertically (x) -> x + 1

    if e.keyCode == @ARROW_UP
      return navigateVertically (x) -> x - 1

    otherTableJump = ->
      row = other_table.find("tr:nth-of-type(#{rowIndex})")

      editable = row.find('td .editable').first()
      return focusElement(editable)

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

      focusElement(next)

    if navigatable.atEnd && e.keyCode == @ARROW_RIGHT
      return navigateHorizontally (x) -> x + 1

    if navigatable.atStart && e.keyCode == @ARROW_LEFT
      return navigateHorizontally (x) -> x - 1
