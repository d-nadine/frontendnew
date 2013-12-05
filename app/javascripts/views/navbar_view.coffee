Radium.NavbarView = Ember.View.extend
  didInsertElement: (event) ->
    $collapse = @$('.nav-collapse')
    $collapse.on('click', 'a', ->
      $collapse.collapse('hide')
    )

  willDestroyElement: ->
    @$('.nav-collapse').off('click')