require 'mixins/views/trigger_scroller_resize'

Radium.ScrollableListItemMixin = Ember.Mixin.create Radium.TriggerScrollerResizeMixin,
  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', this, 'triggerScrollbarResize'

  willDestroyElement: ->
    @triggerScrollbarResize()
