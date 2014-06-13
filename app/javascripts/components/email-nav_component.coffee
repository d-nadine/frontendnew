Radium.EmailNavComponent = Ember.Component.extend
  actions:
    previous: ->
      @send 'navigate', false

    next: ->
      @send 'navigate', true

    navigate: (forward) ->
      emailCoords = @getEmailCoords()

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

      unless next = emailCoords[nextIndex]
        return

      ele = $(next.selector)
      Ember.$.scrollTo("##{ele.get(0).id}", 800, {offset: -100})

  classNameBindings: [':email-nav']

  getEmailCoords: ->
    emails = @get('emails')

    return unless emails.get('length')

    coords = emails.map((email) ->
      selector = ".email-history [data-id='#{email.get('id')}']"
      ele = $(selector)
      return unless ele.length

      index = emails.indexOf email
      top  = ele.offset().top
      bottom = ele.offset().top + ele.outerHeight(true)

      index: index
      top: top
      bottom: bottom
      node: ele
      selector: selector
    ).compact()

    unless coords.length == emails.get('length')
      return []

    coords
