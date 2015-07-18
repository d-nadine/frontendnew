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
