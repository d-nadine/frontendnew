Radium.XDrawerComponent = Ember.Component.extend
  actions:
    closeDrawer: ->
      sendClose = =>
        @sendAction 'closeDrawer'
        false

      if @get('_state') isnt 'inDOM'
        return sendClose()

      el = @$()

      return sendClose unless el.length

      el.removeClass 'open'

      el.one $.support.transition.end, sendClose

      false

  classNames: ['drawer-view']

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$()[0].offsetWidth

    @$().addClass 'open'

    el = this.$()

    self = this

    $('body').on 'click.xdrawer', (e) ->
      target = $(e.target)

      return unless el.hasClass('open')

      if ['.xdrawer-component', '.xmodal-component'].any((className) -> (target.parents(className).length))
        return

      if target.hasClass 'dismiss-single'
        return false

      classNames = e.target.className.split(' ')

      drawerIcons = ['notifications-link', 'ss-notifications', 'email-folders', 'ss-inbox', 'ss-clock', 'as-result-item', 'ss-delete', 'more-text', 'ss-standard', 'add-signature']

      if Ember.EnumerableUtils.intersection(classNames, drawerIcons).length
        return false

      if e.target.tagName == "A"
        self.send "closeDrawer"
        return false

      return if target.hasClass('ss-clock')
      return if target.hasClass('badge-important')
      return if $.contains(el[0], e.target)

      self.send "closeDrawer"

      e.stopPropagation()
      e.preventDefault()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    $('body').off 'click.xdrawer'
