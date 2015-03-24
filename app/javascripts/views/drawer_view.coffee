require 'lib/radium/scrollable_mixin'

Radium.DrawerView = Radium.View.extend Radium.ScrollableMixin,
  classNames: ['drawer-view']

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$()[0].offsetWidth
    @$().addClass 'open'

    controller = @controller

    drawerAction = controller.get('drawerAction')

    Ember.assert "You must set a drawer action", drawerAction

    ele = this.$()
    $('body').on 'click.drawer-actions', (e) ->
      target = $(e.target)

      return unless controller.get('drawerOpen')

      if target.hasClass 'dismiss-single'
        return false

      classNames = e.target.className.split(' ')

      drawerIcons = ['notifications-link', 'email-folders', 'ss-inbox', 'ss-clock']

      if Ember.EnumerableUtils.intersection(classNames, drawerIcons).length
        return false

      if e.target.tagName == "A"
        controller.send drawerAction
        return false

      return if target.hasClass('ss-clock')
      return if target.hasClass('badge-important')
      return if $.contains(ele[0], e.target)
      controller.send drawerAction
      e.stopPropagation()
      e.preventDefault()

  willDestroyElement: ->
    $('body').off 'click.drawer-actions'
