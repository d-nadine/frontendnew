require 'controllers/sidebar/multiple_base_controller'
require 'mixins/multiple_address_behaviour'

Radium.AddressesForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  reset: ->
    @_super.apply this, arguments
    @set 'addresses', Ember.A()

Radium.SidebarAddressesController = Radium.MultipleBaseController.extend Radium.MultipleAddressBehaviour,
  actions:
    commit: ->
      model = @get('content')

      @setAddressFromHash model, @get('form.addresses'), @emailIsValid

      model.save(this)

    setForm: ->
      recordArray = @get(@recordArray)
      formArray = @get("form.#{@recordArray}")

      unless recordArray.get('length')
        companyAddress = @get('company.primaryAddress')

        if companyAddress
          hash = Ember.Object.create(companyAddress.getAddressHash())
          formArray.pushObject hash
          return

        formArray.pushObject Ember.Object.create
          name: 'work'
          email: null
          phone: null
          street: null
          city: null
          state: null
          zipcode: null
          country: "US"
          isPrimary: true

        return

      recordArray.forEach (item) ->
        hash = Ember.Object.create(item.getAddressHash())
        hash.set 'record', item
        formArray.pushObject hash


  isValid: true
  recordArray: 'addresses'

  isCompany: Ember.computed 'model', ->
    @get('model').constructor is Radium.Company

  form: Ember.computed ->
    Radium.AddressesForm.create()
