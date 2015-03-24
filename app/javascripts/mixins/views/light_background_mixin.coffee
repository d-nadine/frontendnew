Radium.LightBackgroundMixin = Ember.Mixin.create
  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    $('body').addClass('bright-background')

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    $('body').removeClass('bright-background')
