require 'controllers/sidebar/multiple_base_controller'

Radium.AddressesForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  reset: ->
    @_super.apply this, arguments
    @set 'addresses', Ember.A()

Radium.SidebarAddressesController = Radium.MultipleBaseController.extend
  actions:
    commit: ->
      @get("form.#{@recordArray}").forEach (item) =>
        if item.hasOwnProperty 'record'
          item.record.setProperties
            isPrimary: item.get('isPrimary')
            name: item.get('name')
            email: item.get('email')
            phone: item.get('phone')
            street: item.get('street')
            city: item.get('city')
            state: item.get('state')
            zipcode: item.get('zipcode')
            country: item.get('country')
        else
          if !Ember.isEmpty(item.get('street')) || !Ember.isEmpty(item.get('state')) || !Ember.isEmpty(item.get('city')) || !Ember.isEmpty(item.get('zipcode')) || !Ember.isEmpty(item.get('email')) || !Ember.isEmpty(item.get('phone'))
            @get("content.#{@recordArray}").createRecord item.getProperties('name', 'isPrimary', 'street', 'city', 'state', 'zipcode', 'country', 'email', 'phone')

      model = @get('content')

      model.one 'becameInvalid', (result) =>
        @send 'flashError', 'A validation error has occurred.'
        result.reset()

      model.one 'bacameError', (result) =>
        @send 'flashError', 'An error has occurred and the update did not occurr.'
        result.reset()

      @get('content.transaction').commit()

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
          email: ''
          phone: ''
          street: ''
          city: ''
          state: ''
          zipcode: ''
          country: ''
          isPrimary: true

        return

      recordArray.forEach (item) =>
        hash = Ember.Object.create(item.getAddressHash())
        hash.set 'record', item
        formArray.pushObject hash


  isValid: true
  recordArray: 'addresses'

  isCompany: Ember.computed 'model', ->
    @get('model').constructor is Radium.Company

  form: ( ->
    Radium.AddressesForm.create()
  ).property()
