Radium.EmailNavComponent = Ember.Component.extend Radium.GetEmailCoords,
  actions:
    previous: ->
      @send 'navigate', false

    next: ->
      @send 'navigate', true

    navigate: (forward) ->
      emails = @get('emails')

      emailCoords = @getEmailCoords(emails)

      unless emailCoords.length
        return

      scrollElement = $(window)
      scrollTop = scrollElement.scrollTop() + 250

      current = emailCoords.find (coord) ->
        scrollTop >= coord.top && scrollTop <= coord.bottom

      return unless current

      index = emailCoords.indexOf current

      scrolledToBottom = ->
        container = $('body').get(0)

        height = container.clientHeight
        scroll = container.scrollHeight
        position = container.scrollTop

        current = (height + position)
        leeway = 3

        return ((scroll > (current - leeway)) && (scroll < (current + leeway)))

      if !forward && scrolledToBottom()
        nextIndex = (emailCoords.length - 2)
      else
        nextIndex = if forward then (index + 1) else (index - 1)

      if (emailCoords.length > 5) && (nextIndex == (emailCoords.length - 2))
        @sendAction 'loadMore'

      unless next = emailCoords[nextIndex]
        return

      ele = $(next.selector)
      Ember.$.scrollTo("##{ele.get(0).id}", 800, {offset: -100})

  classNameBindings: [':email-nav']
