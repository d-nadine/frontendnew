Radium.ColumnSelectorComponent = Ember.Component.extend
  classNames: ['viewed']

  mouseEnter: (e) ->
    $('.variadic-table-component tr td.column-selector').removeClass('viewed')

  mouseLeave: (e) ->
    $('.variadic-table-component tr td.column-selector').addClass('viewed')
