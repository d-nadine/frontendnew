Radium.MapView = Ember.View.extend
  templateName: 'forms/map'
  classNameBindings: [
    ':control-box'
    ':datepicker-control-box'
    ':field'
    ':map'
  ]

  leader: 'location'

  locationField: Ember.TextField.extend()

  showMap: (event) ->
    false



