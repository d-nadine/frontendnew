Radium.NotificationsView = Radium.DrawerView.extend
  classNames: 'notifications'

  setup: Ember.on 'didInsertElement', ->
    controller = @controller
    ele = this.$()
    $('body').on 'click.notifications', (e) ->
      return unless controller.get('drawerOpen')

      target = $(e.target)
      if e.target.tagName == "A" && target.hasClass('notifications-link')
        return false

      if e.target.tagName == "A"
        controller.send 'toggleNotifications'
        return false

      return if target.hasClass('ss-clock')
      return if target.hasClass('badge-important')
      return if $.contains(ele[0], e.target)
      controller.send 'toggleNotifications'
      e.stopPropagation()
      e.preventDefault()

  willDestroyElement: ->
    $('body').off 'click.notifications'

