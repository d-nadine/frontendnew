Radium.MultipleAddressComponent = Ember.Component.extend Radium.GeoLocationMixin,
  Radium.AddressesMixin,
  actions:
    changeAddress: (address) ->
      @$('#autocomplete').val('')
      Ember.run.next =>
        @get('addresses').setEach('isCurrent', false)
        address.set 'isCurrent', true
        @set 'current', address

      false

  autocomplete: null

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @get('parent').on 'modelReset', this, 'onModelReset'
    @get('parent').on 'modelChanged', this, 'onModelChanged'

    model = @get('parent.model')

    if model.get('isNew')
      @onModelReset()
    else
      @onModelChanged(model)

    @$('#autocomplete').on 'focus', @showAddressFields.bind(this)

    return @initializeGoogleGeo()

  showAddressFields: ->
    return unless addressField = @$('.address-body')

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
    defaultAddresses = @defaultAddresses(@get('hasEmail'))

    unless addresses.get('length')
       @set('addresses', defaultAddresses)
       return @set('current', @get('addresses').findProperty('isPrimary'))

    @showAddressFields()

    unless model.get('addresses').find( (a) -> a.get('isPrimary'))
      model.get('addresses.firstObject').set('isPrimary', true)

      unless addresses.find((a) -> a.get('name')?.toLowerCase() == "work")
        model.get('addresses.firstObject').set('name', 'work')

      @sendAction('saveModel', true) if @get('saveModel')

    hashes = addresses.map (a) ->
      Ember.merge(Ember.Object.create(a.getAddressHash()), record: a)

    if hashes.length == 1
      home = defaultAddresses.reject( (a) -> a.get('isCurrent')).get('firstObject')
      home.set 'isPrimary', false
      hashes.push home

    @set 'addresses', hashes

    unless hashes.any((a) -> a.get('isPrimary'))
      hashes.get('firstObject').set 'isPrimary', true

    @set 'current', hashes.findProperty 'isPrimary'
