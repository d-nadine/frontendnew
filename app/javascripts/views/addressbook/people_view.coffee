Radium.PeopleIndexView = Radium.View.extend
  setup: ( ->
    @$('ul.col-menu li').on 'click.col-men', ->
      check = $(this).find 'input[type=checkbox]'
      check.prop('checked', !check.prop('checked'))
      return false
  ).on 'didInsertElement'

  teardown: (->
    @$('ul.col-menu').off 'click.col-men'
  ).on 'willDestroyElement'