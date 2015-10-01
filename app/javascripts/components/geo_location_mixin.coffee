Radium.GeoLocationMixin = Ember.Mixin.create
  componentForm:
    "street_number": 'short_name',
    "route": 'long_name',
    "locality": 'long_name',
    "administrative_area_level_1": 'short_name',
    "country": 'short_name',
    "postal_code": 'short_name'

  modelMap:
    "route": "street"
    "locality": "city"
    "postal_code": "zipcode"
    "administrative_area_level_1": 'state',
    "country": "country"

  autocompletes: []
  listenerHandles: []

  initializeGoogleGeo: (elements)->
    # Create the autocomplete object, restricting the search
    # to geographical location types.
    self = this

    @autocompletes.clear()
    @listenerHandles.clear()
    elements.forEach (el) ->
      autocomplete = new (google.maps.places.Autocomplete)(document.getElementById(el.attr('id')), types: [ 'geocode' ])

      self.autocompletes.push(autocomplete)

      handle = google.maps.event.addListener(autocomplete, 'place_changed', ->
        self.fillInAddress(autocomplete))

      self.listenerHandles.pushObject handle

  fillInAddress: (autocomplete) ->
    place = autocomplete.getPlace()

    for component of @componentForm
      input = $(component)
      input.val('')
      input.attr('disabled', false)

    i = 0
    l = place.address_components?.length || 0

    while i < l
      addressType = place.address_components[i].types[0]
      if @componentForm[addressType]
        val = place.address_components[i][@componentForm[addressType]]
        if addressType == 'route'
          street_number = place.address_components[0]['long_name']
          val = "#{street_number} #{val}"

        if addressType != "street_number"
          @set("current.#{@modelMap[addressType]}", val)
      i++

    $('#autocomplete').val('')

  # Bias the autocomplete object to the user's geographical location,
  # as supplied by the browser's 'navigator.geolocation' object.
  geolocate: ->
    self = this

    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        geolocation = new (google.maps.LatLng)(position.coords.latitude, position.coords.longitude)
        circle = new (google.maps.Circle)(
          center: geolocation
          radius: position.coords.accuracy)
        self.autocompletes.forEach (autocomplete) ->
          autocomplete.setBounds circle.getBounds()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    @get('listenerHandles').forEach (handle) ->
      google.maps.event.removeListener handle
