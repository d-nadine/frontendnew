Radium.ColumnSelectorComponent = Ember.Component.extend
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

    false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    grouped = []

    @get('columnSelection').forEach (c) ->
      group = if g = grouped.find((el) -> el.group == c.group)
                 g
              else
                g = {group: c.group, columns: []}
                grouped.push(g)

      g.columns.push c

    @set 'groups', grouped

    $(document).on 'click.column-selector', =>
      el = @$('.column-selector-dialog')

      return unless el && el.length

      el.removeClass('open')

      false

  _teardown: Ember.on 'willInsertElement', ->
    @_super.apply this, arguments

    $(document).off 'click.column-selector'

  classNames: ['viewed']

  mouseEnter: (e) ->
    $('.variadic-table-component tr td.column-selector').removeClass('viewed')

  mouseLeave: (e) ->
    $('.variadic-table-component tr td.column-selector').addClass('viewed')
