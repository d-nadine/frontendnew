Radium.GeoLocationMixin = Ember.Mixin.create
  componentForm:
    "street_number": 'short_name',
    "route": 'long_name',
    "postal_town": 'long_name',
    "administrative_area_level_1": 'short_name',
    "country": 'long_name',
    "postal_code": 'short_name'

  modelMap:
    "route": "street"
    "postal_town": "city"
    "postal_code": "zipcode"
    "country": "country"

  initializeGoogleGeo: ->
    # Create the autocomplete object, restricting the search
    # to geographical location types.
    @autocomplete = new (google.maps.places.Autocomplete)(document.getElementById('autocomplete'), types: [ 'geocode' ])
    google.maps.event.addListener @autocomplete, 'place_changed', =>
      @fillInAddress()

  fillInAddress: ->
    place = @autocomplete.getPlace()

    for component of @componentForm
      input = $(component)
      input.val('')
      input.attr('disabled', false)

    i = 0
    while i < place.address_components.length
      addressType = place.address_components[i].types[0]
      if @componentForm[addressType]
        val = place.address_components[i][@componentForm[addressType]]
        if addressType == 'route'
          street_number = place.address_components[0]['long_name']
          val = "#{street_number} #{val}"

        if addressType != "street_number"
          @set("current.#{@modelMap[addressType]}", val)
      i++

  # Bias the autocomplete object to the user's geographical location,
  # as supplied by the browser's 'navigator.geolocation' object.
  geolocate: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        geolocation = new (google.maps.LatLng)(position.coords.latitude, position.coords.longitude)
        circle = new (google.maps.Circle)(
          center: geolocation
          radius: position.coords.accuracy)
        @autocomplete.setBounds circle.getBounds()
