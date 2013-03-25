Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  itemsDidChange: (->
    return unless @state is 'inDOM'
    Ember.run.scheduleOnce 'afterRender', this, 'shouldScroll'
  ).observes('controller.length')
