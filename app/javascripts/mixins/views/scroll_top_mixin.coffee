Radium.ScrollTopMixin = Ember.Mixin.create
  setup: (->
    Ember.run.scheduleOnce 'afterRender', this, 'scrollToTop'
  ).on 'didInsertElement'

  scrollToTop: ->
    window.scrollTo(0,0)
