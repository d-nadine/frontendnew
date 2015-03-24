require 'lib/radium/scrollable_mixin'

Radium.DrawerView = Radium.View.extend Radium.ScrollableMixin,
  classNames: ['drawer-view']

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$()[0].offsetWidth
    @$().addClass 'open'

    controller = @controller
    ele = this.$()
    $('body').on 'click.notifications', (e) ->
      return unless controller.get('drawerOpen')

      target = $(e.target)
      if target.hasClass 'dismiss-single'
        return false

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
