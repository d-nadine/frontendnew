Radium.EmailPropertiesMixin = Ember.Mixin.create
  isScheduled: Ember.computed 'sendTime', 'isDraft', ->
    !!@get('sendTime') && @get('isDraft')

  sendTimeFormatted: Ember.computed 'sendTime', ->
    @get('sendTime').toHumanFormatWithTime()

  checkForResponseFormatted: Ember.computed 'checkForResponse', ->
    @get('checkForResponse')?.toHumanFormatWithTime()
