Radium.AddressMultipleField = Radium.MultipleField.extend
  sourceBinding: 'parentView.source'
  companyBinding: 'controller.company'

  template: Ember.Handlebars.compile """
    {{#with view.current}}
      <div class="addresses">
        <div class="control-group whole">
          {{view Ember.TextField classNames="field input-xlarge" valueBinding="street" placeholderBinding="view.leader" readonlyBinding="view.readonly"}}
        </div>
        <div class="control-group whole">
          {{view Ember.TextField  valueBinding="city" classNames="field input-xlarge city" placeholder="City" readonlyBinding="view.readonly"}}
        </div>
        <div class="control-group broken">
          {{view Ember.TextField valueBinding="state" classNames="field state" placeholder="State" readonlyBinding="view.readonly" }}
          {{view Ember.TextField valueBinding="zipcode" classNames="field zip" placeholder="Zip code" readonlyBinding="view.readonly"}}
        </div>
      </div>
      <div>
        <a href="#"><i class="icon-location"></i></a>
      </div>
    {{/with}}
  """

  showAddNew: ( ->
    return if @get('readonly')

    if @get('source.length') > 1
      lastIndex = @get('source.length') - 1
      return ((@get('current') == @get('source').objectAt(lastIndex)) && (@hasValue()))

    @hasValue()
  ).property('source.[]', 'showdropdown', 'current.street', 'current.city', 'current.state', 'current.zip')

  hasValue: ->
    return true if @get('current.street.length') > 1
    return true if @get('current.city.length') > 1
    return true if @get('current.state.length') > 1
    return true if @get('current.zipcode.length') > 1

  clearValue: ->
    return unless @get('controller.isNew')
    @set('current.street', '')
    @set('current.city', '')
    @set('current.state', '')
    @set('current.zipcode', '')

  companyDidChange: ( ->
    return if @get('parentView.source.length') > 1

    if ((!@get('company')) || (!@get('company.primaryAddress')))
      @clearValue()

    current = @get('current')
    companyAddress = @get('company.primaryAddress')

    return unless companyAddress

    current.set('street', companyAddress.get('street'))
    current.set('city', companyAddress.get('city'))
    current.set('state', companyAddress.get('state'))
    current.set('zipcode', companyAddress.get('zipcode'))
    current.set('country', companyAddress.get('country'))
  ).observes('company')

Radium.AddressMultipleField.reopenClass
  getNewRecord: (label) ->
    isPrimary = @get('source.length') == 0

    address = @get('company.primaryAddress')

    addressDefaults =
      if @get('source.length') ==  0 && address?.get('value')
        street: address.serialize()
      else
        street: ''
        city: ''
        state: ''
        zipcode: ''
        country: ''
        isPrimary: isPrimary
        name: label

    if @get('source').createRecord
       @get('source').createRecord(addressDefaults)
    else
       Ember.Object.create(addressDefaults)
