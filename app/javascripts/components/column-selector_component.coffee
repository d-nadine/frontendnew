Radium.ColumnSelectorComponent = Ember.Component.extend
  actions:
    toggleColumnSelection: ->
      @sendAction "toggleColumnSelection"

      false

  click: (e) ->
    el = @$('.column-selector-dialog')

    el.toggleClass 'open'

    return unless el.hasClass('open')

    th = @$()

    rect = th.get(0).getBoundingClientRect()

    dropdown = @$('.dropdown-menu')

    dropdown.css
      position: 'fixed'
      top: rect.top
      left: rect.right - dropdown.width() - th.width()

    addOverlay = ->
      overlay = $('<div class="modal-backdrop"/>').appendTo(document.body)

      overlay.one 'click', ->
        overlay.remove()
        el.removeClass('open')

    Ember.run.next ->
      addOverlay()

    false

  _tearDown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    if overlay = $('.modal-backdrop')
      overlay.remove()

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    columnSelection = @get('columnSelection')

    Ember.assert "you need to specify a columnSection for the ColumnSelectorComponent", columnSelection

    grouped = []

    columnSelection.forEach (c) ->
      group = if g = grouped.find((el) -> el.group == c.group)
                 g
              else
                g = {group: c.group, columns: []}
                grouped.push(g)

      g.columns.push c

    @set 'groups', grouped

  classNames: ['viewed']

  mouseEnter: (e) ->
    $('.variadic-table-component tr td.column-selector').removeClass('viewed')

  mouseLeave: (e) ->
    $('.variadic-table-component tr td.column-selector').addClass('viewed')
