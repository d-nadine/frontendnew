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
    return unless addressField = @$('#addressField')

    return unless addressField.length

    unless addressField.is(':visible')
      addressField.slideDown 200
      @geolocate()

  onModelReset: (from) ->
    return if @isDestroying || @isDestroyed

    @$('#addressField')?.slideUp()
    @set 'addresses', @defaultAddresses()
    @set 'current', @get('addresses').find (a) -> a.get('isPrimary')

  onModelChanged: (model) ->
    return if @isDestroying || @isDestroyed

    addresses = model.get('addresses')
    defaultAddresses = @defaultAddresses()

    unless addresses.get('length')
      return @set('addresses', defaultAddresses)

    @showAddressFields()

    unless model.get('addresses').find( (a) -> a.get('isPrimary'))
      model.get('addresses.firstObject').set('isPrimary', true)

      unless addresses.find((a) -> a.get('name')?.toLowerCase() == "work")
        model.get('addresses.firstObject').set('name', 'work')

      @sendAction 'saveModel', true

    hashes = addresses.map (a) ->
      Ember.merge(Ember.Object.create(a.getAddressHash()), record: a)

    if hashes.length == 1
      home = defaultAddresses.reject( (a) -> a.get('isCurrent')).get('firstObject')
      home.set 'isPrimary', false
      hashes.push home

    sorted = hashes.sort (a, b) ->
      if a.get('isPrimary') then -1 else 1

    @set 'addresses', sorted

    unless sorted.any((a) -> a.get('isPrimary'))
      sorted.get('firstObject').set 'isPrimary', true

    @set 'current', sorted.findProperty 'isPrimary'
