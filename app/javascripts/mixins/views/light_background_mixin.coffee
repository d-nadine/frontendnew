Radium.LightBackgroundMixin = Ember.Mixin.create
  didInsertElement: ->
    $('body').addClass('bright-background')

  willDestroyElement: ->
    $('body').removeClass('bright-background')
