Radium.EmailNavComponent = Ember.Component.extend
  actions:
    previous: ->
      console.log 'pervious'

    next: ->
      emailCoords = @getEmailCoords()

      unless emailCoords.length
        return

      scrollElement = $(window)
      scrollTop = scrollElement.scrollTop() + 100

      emailCoords.forEach (coord) ->
        if scrollTop < coord.bottom && coord.index != 0
          Ember.$.scrollTo(coord.selector, 800, {offset: -100})

  classNameBindings: [':email-nav']

  getEmailCoords: ->
    emails = @get('emails')
    return unless emails.get('length')

    coords = emails.map((email) ->
      selector = ".email-history [data-id='#{email.get('id')}']"
      outer = $(selector)
      return unless outer.length

      ele = outer.find('.iframe-container')
      index = emails.indexOf email
      top  = ele.position().top + $(window).scrollTop()
      bottom = ele.position().top + ele.outerHeight(true)

      index: index
      top: top
      bottom: bottom
      node: ele
      selector: selector
    ).compact()

    unless coords.length == emails.get('length')
      return []

    coords
