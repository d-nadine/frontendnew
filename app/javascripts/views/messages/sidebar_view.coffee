Radium.MessagesSidebarView = Radium.FixedSidebarView.extend
  isSyncing: Ember.computed.oneWay 'controller.isSyncing'

  isSyncingDidChange: ( ->
    $(window).trigger('resize.jscrollpane')
  ).observes('isSyncing')
