Radium.ScrollableListItemMixin = Ember.Mixin.create
  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', ->
      Ember.$(window).trigger 'stickyChange'

  willDestroyElement: ->
    Ember.$(window).trigger 'stickyChange'