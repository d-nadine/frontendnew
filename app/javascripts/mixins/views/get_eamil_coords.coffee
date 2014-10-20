Radium.GetEmailCoords = Ember.Mixin.create
  getEmailCoords: (emails) ->
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
