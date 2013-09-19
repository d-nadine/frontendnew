Radium.CalendarSidebarView = Radium.FixedSidebarView.extend
  classNameBindings: ['controller.isDifferentUser', ':calendar-sidebar']
  didInsertElement: ->
    @_super()
    Ember.run.scheduleOnce 'afterRender', this, ->
      @get('controller').addObserver('content.length', =>
        Ember.run.later( =>
          @setSidebarHeight()
        , 50);
      )