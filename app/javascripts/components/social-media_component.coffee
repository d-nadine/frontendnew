Radium.SocialMediaComponent = Ember.Component.extend
  tagName: 'a'
  attributeBindings: ['href', 'target']

  classNameBindings: ['hasMedia:active']

  personsMedia: Ember.computed 'person.contactInfo.socialProfiles.[]', 'socialMedia', ->
    socialMedia = @get('socialMedia')

    @get('person.contactInfo.socialProfiles').find (p) ->
      p.get('type') == socialMedia


  hasMedia: Ember.computed.bool 'personsMedia'

  href: Ember.computed 'personsMedia', 'hasMedia', ->
    return "#" unless @get('hasMedia')

    @get('personsMedia.url')

  badge: Ember.computed 'socialMedia', ->
    "ss-#{@get('socialMedia')}"

  target: "_new"

  click: (e) ->
    unless @get('hasMedia')
      return e.preventDefault()

    @_super.apply this arguments
