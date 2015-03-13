Radium.ProfileService = Ember.Object.extend Ember.Evented,
  queryProfile: (email) ->
    self = this

    Radium.QueryProfile.find(email: email).then((results) ->
      return unless results.get('length')

      a.trigger 'profileQueried', results.get('firstObject')
    )
