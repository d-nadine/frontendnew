Radium.ScrollTopMixin = Ember.Mixin.create
  didInsertElement: ->
    @_super.apply this, arguments
    window.scrollTo(0,0)
