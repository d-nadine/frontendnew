Radium.MultipleAddressComponent = Ember.Component.extend Radium.GeoLocationMixin,
  Radium.AddressesMixin,
  actions:
    changeAddress: (address) ->
      @$('#autocomplete').val('')
      @set 'current', address

  autocomplete: null

  setup: Ember.on 'didInsertElement', ->
    @get('targetObject.targetObject').on 'modelChanged', this, 'onModelChanged'
    autocomplete = @$('#autocomplete')
    addressField = @$('#addressField')

    autocomplete.on 'focus', =>
      unless addressField.is(':visible')
        addressField.slideDown 200
      @geolocate()

    return @initializeGoogleGeo()

  onModelChanged: (model) ->
    addresses = model.get('addresses')
    unless addresses.get('length')
      return @set('addresses', @defaultAddresses())
