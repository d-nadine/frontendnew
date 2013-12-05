Radium.NavbarView = Ember.View.extend
  templateName: 'navbar'
  didInsertElement: (event) ->
    $collapse = @$('.nav-collapse')
    $collapse.on('click', 'a', ->
      $collapse.collapse('hide')
    )

  willDestroyElement: ->
    @$('.nav-collapse').off('click')