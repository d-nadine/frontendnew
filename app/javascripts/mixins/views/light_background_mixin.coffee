Radium.LightBackgroundMixin = Ember.Mixin.create
  didInsertElement: ->
    $('html').toggleClass('bright-background')

  willDestroyElement: ->
    $('html').toggleClass('bright-background')
