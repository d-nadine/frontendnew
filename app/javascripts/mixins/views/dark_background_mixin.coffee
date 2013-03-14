Radium.DarkBackgroundMixin = Ember.Mixin.create
  didInsertElement: ->
    $('html').toggleClass('gray-background')

  willDestroyElement: ->
    $('html').toggleClass('gray-background')
