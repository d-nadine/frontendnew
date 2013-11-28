Radium.EmailPropertiesMixin = Ember.Mixin.create
  isScheduled: ( ->
    !!@get('sendTime') && @get('isDraft')
  ).property('sendTime', 'isDraft')

  sendTimeFormatted: ( ->
    @get('sendTime').toHumanFormatWithTime()
  ).property('sendTime')
