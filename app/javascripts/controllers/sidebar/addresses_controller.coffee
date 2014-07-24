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
        setProperties = (record) ->
          ["email", "phone", "street", "city", "state", "zipcode", "country", "isPrimary"].forEach (field) ->
            record.set(field, item.get(field)) unless Ember.isEmpty($.trim(item.get(field)))

        email = item.get('email')

        if !Ember.isEmpty(email) && !@emailIsValid(email)
          @send 'flashError', "Not a valid email address"
          return

        if item.hasOwnProperty 'record'
          item.record.setProperties
            name: item.get('name')

          setProperties item.record
        else
          if !Ember.isEmpty(item.get('street')) || !Ember.isEmpty(item.get('state')) || !Ember.isEmpty(item.get('city')) || !Ember.isEmpty(item.get('zipcode')) || !Ember.isEmpty(item.get('email')) || !Ember.isEmpty(item.get('phone'))
            record = @get("content.#{@recordArray}").createRecord()
            setProperties record

      model = @get('content')

      model.one 'becameInvalid', (result) =>
        @send 'flashError', result
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
          email: null
          phone: null
          street: null
          city: null
          state: null
          zipcode: null
          country: null
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

  form: ( ->
    Radium.AddressesForm.create()
  ).property()
