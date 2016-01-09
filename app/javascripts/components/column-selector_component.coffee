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

    position = th.position()

    p position

    dropdown = @$('.dropdown-menu')

    dropdown.css
      position: 'absolute'
      top: position.top + th.height()
      left: position.left - dropdown.outerWidth(true) + th.outerWidth()

    Radium.Common.addOverlay ->
      Radium.Common.removeOverlay()
      el.removeClass('open')

    false

  reapply: ->
    Ember.run.scheduleOnce('render', this, 'rerender')

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments
    @EventBus.subscribe 'rerender-column-selector', this, 'reapply'

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    columnSelection = @get('columnSelection')

    Ember.assert "you need to specify a columnSelection for the ColumnSelectorComponent", columnSelection

    grouped = []

    columnSelection.forEach (c) ->
      group = if g = grouped.find((el) -> el.group == c.group)
                 g
              else
                g = {group: c.group, columns: []}
                grouped.push(g)

      g.columns.push c

    @set 'groups', grouped


  _tearDown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    Radium.Common.removeOverlay()

    @EventBus.unsubscribe 'rerender-column-selector'

  classNames: ['viewed']

  mouseEnter: (e) ->
    $('.variadic-table-component tr td.column-selector').removeClass('viewed')

  mouseLeave: (e) ->
    $('.variadic-table-component tr td.column-selector').addClass('viewed')
