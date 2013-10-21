Radium.NotificationsView = Radium.DrawerView.extend
  classNames: 'notifications'
  didInsertElement: ->
    @_super()
    controller = @controller
    ele = this.$()
    $('body').on 'click.notifications', (e) =>
      return unless controller.get('drawerOpen')

      if e.target.tagName == "A"
        controller.send 'toggleNotifications'
        return

      target = $(e.target)
      return if target.hasClass('ss-clock')
      return if $.contains(ele[0], e.target)
      controller.send 'toggleNotifications'
      e.stopPropagation()
      e.preventDefault()

    Ember.run.scheduleOnce 'afterRender', this, ->
      @get('controller').addObserver('content.length', =>
        Ember.run.later( =>
          @setSidebarHeight()
        , 500)
      )

  willDestroyElement: ->
    $('body').off 'click.notifications'

