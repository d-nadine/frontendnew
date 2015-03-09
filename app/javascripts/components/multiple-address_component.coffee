Radium.MultipleAddressComponent = Ember.Component.extend Radium.GeoLocationMixin,

  autocomplete: null

  setup: Ember.on 'didInsertElement', ->
    autocomplete = @$('#autocomplete')
    addressField = @$('#addressField')

    autocomplete.on 'focus', =>
      unless addressField.is(':visible')
        addressField.slideDown 200
      @geolocate()

    return @initializeGoogleGeo()
