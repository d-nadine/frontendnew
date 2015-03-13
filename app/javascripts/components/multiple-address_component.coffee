Radium.MultipleAddressComponent = Ember.Component.extend Radium.GeoLocationMixin,
  Radium.AddressesMixin,
  actions:
    changeAddress: (address) ->
      @$('#autocomplete').val('')
      @set 'current', address

  autocomplete: null

  setup: Ember.on 'didInsertElement', ->
    @get('parent').on 'modelReset', this, 'onModelReset'
    @get('parent').on 'modelChanged', this, 'onModelChanged'

    @onModelReset()

    @$('#autocomplete').on 'focus', @showAddressFields.bind(this)

    return @initializeGoogleGeo()

  showAddressFields: ->
    addressField = @$('#addressField')

    return unless addressField.length

    unless addressField.is(':visible')
      addressField.slideDown 200
      @geolocate()

  onModelReset: (from) ->
    @$('#addressField').slideUp()
    @set 'addresses', @defaultAddresses()
    @set 'current', @get('addresses').find (a) -> a.get('isPrimary')

  onModelChanged: (model) ->
    addresses = model.get('addresses')
    defaultAddresses = @defaultAddresses()

    unless addresses.get('length')
      return @set('addresses', defaultAddresses)

    @showAddressFields()

    unless model.get('addresses').find( (a) -> a.get('isPrimary'))
      model.get('addresses.firstObject').set('isPrimary', true)

      unless addresses.find((a) -> a.get('name')?.toLowerCase() == "work")
        model.get('addresses.firstObject').set('name', 'work')

      @sendAction 'saveModel'

    hashes = addresses.map (a) -> a.getAddressHash()

    if hashes.length == 1
      home = defaultAddresses.reject( (a) -> a.get('isCurrent')).get('firstObject')
      hashes.push home

    @set 'addresses', hashes
    @set 'current', hashes.findProperty 'isPrimary'
