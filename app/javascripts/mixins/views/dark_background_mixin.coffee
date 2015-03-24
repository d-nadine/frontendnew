Radium.DarkBackgroundMixin = Ember.Mixin.create
  setup: Ember.on 'disInsertElement', ->
    @_super.apply this, arguments
    $('html').toggleClass('gray-background')

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    $('html').toggleClass('gray-background')
