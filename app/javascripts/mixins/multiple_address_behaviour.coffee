Radium.MultipleAddressBehaviour = Ember.Mixin.create
  setAddressFromHash: (model, formArray, emailIsValid) ->
    setProperties = (record, item) ->
      ["email", "phone", "street", "city", "state", "zipcode", "country", "isPrimary", "name"].forEach (field) ->
        record.set(field, item.get(field)) unless Ember.isEmpty($.trim(item.get(field)))

    formArray.forEach (item) =>
      email = item.get('email')

      if !Ember.isEmpty(email) && !emailIsValid(email)
        @send 'flashError', "Not a valid email address"
        return

      if item.hasOwnProperty 'record'
        setProperties item.record, item
      else
        any = ['street', 'state', 'city', 'zipcode', 'email', 'phone', 'country'].any (prop) -> not Ember.isEmpty(item.get(prop))

        if any
          record = model.get("addresses").createRecord()
          setProperties record, item
