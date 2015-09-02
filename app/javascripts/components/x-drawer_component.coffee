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

    el = @$()

    self = this

    addOverlay = ->
      rect = el.get(0).getBoundingClientRect()

      overlay = $("<div class='drawer-overlay'></div>")

      overlay.css(
        position: "absolute"
        top: rect.top + "px"
        left: (rect.right - 10) + "px"
        height: rect.height + "px"
        ).appendTo('body')

      overlay.one 'click', (e) ->
        self.send "closeDrawer"

        e.stopPropagation()
        e.preventDefault()

    el.one $.support.transition.end, addOverlay

    el.get(0).offsetWidth

    el.addClass 'open'

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    unless overlay = $('.drawer-overlay')
      return

    overlay.remove()
