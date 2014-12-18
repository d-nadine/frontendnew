Radium.ScrollTopMixin = Ember.Mixin.create
  didInsertElement: ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, 'scrollToTop'

  scrollToTop: ->
    window.scrollTo(0,0)
