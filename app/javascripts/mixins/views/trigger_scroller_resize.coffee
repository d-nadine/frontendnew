Radium.TriggerScrollerResizeMixin = Ember.Mixin.create
  # FIXME: Make more emberish
  triggerScrollbarResize: ->
    Ember.run.next =>
      Ember.$(window).trigger 'stickyChange'
