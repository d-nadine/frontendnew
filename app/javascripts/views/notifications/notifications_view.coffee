Radium.NotificationsView = Radium.DrawerView.extend
  classNames: 'notifications'
  didInsertElement: ->
    @_super()
    Ember.run.scheduleOnce 'afterRender', this, ->
      @get('controller').addObserver('content.length', =>
        Ember.run.later( =>
          @setSidebarHeight()
        , 500);
      )
