Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  itemsDidChange: (->
    return unless @state is 'inDOM'
    Ember.run.next =>
      @shouldScroll()
  ).observes('controller.length')
