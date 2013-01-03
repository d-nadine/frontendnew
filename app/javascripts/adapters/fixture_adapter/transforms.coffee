Radium.FixtureAdapter.registerTransform 'array',
  fromData: (serialized) ->
    if Ember.isArray(serialized) then serialized else null
  toData: (deserialized) ->
    if Ember.isArray(deserialized) then deserialized else null

Radium.FixtureAdapter.registerTransform 'object',
  fromData: (serialized) ->
    if Ember.none(serialized) then {} else serialized
  toData: (deserialized) ->
    if Ember.none(deserialized) then {} else deserialized

Radium.FixtureAdapter.registerTransform 'datetime'
  fromData: (serialized) ->
    type = typeof serialized

    if type == "string" or type == "number"
      timezone = new Date().getTimezoneOffset()
      serializedDate = Ember.DateTime.parse serialized, @format
      serializedDate.toTimezone timezone
    else if Em.none serialized
      serialized
    else
      null

  toData: (deserialized) ->
    if deserialized instanceof Ember.DateTime
      normalized = deserialized.advance timezone: 0
      normalized.toFormattedString @format
    else if  deserialized == undefined
      undefined
    else
      null

  format: Ember.DATETIME_ISO8601

