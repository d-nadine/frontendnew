Radium.FormArrayBehaviour = Ember.Mixin.create
  actions:
    setPrimary: (item) ->
      Ember.run.next =>
        @get('parent').setEach 'isPrimary', false
        item.set 'isPrimary', true

        if @_actions.stopEditing
          @send 'stopEditing'

    removeSelection: (item) ->
      parent = @get('parent')

      if record = item.get('record')
        retlationShip = if item.record.constructor is Radium.EmailAddress
                          'emailAddresses'
                        else if item.record.constructor is Radium.PhoneNumber
                          'phoneNumbers'
                        else
                          'addresses'

        @send 'removeMultiple', retlationShip, item.get('record')

      @get('parent').removeObject item

      unless parent.get('length')
        @send('stopEditing')

      isPrimary = @get('parent').find (item) -> item.get('isPrimary')

      if isPrimary
        @send('stopEditing')
        return

      nextIsPrimary = parent.find (i) -> i != item

      nextIsPrimary.set 'isPrimary', true

  setModelFromHash: (model, relationship, formArray) ->
      formArray.forEach (item) =>
        if item.hasOwnProperty('record') && item.get('value') != "+1"
          item.record.setProperties(name: item.get('name'), value: item.get('value'), isPrimary: item.get('isPrimary'))
        else
          if item.get('value.length') && item.get('value') != "+1"
            @get("model.#{relationship}").createRecord item.getProperties('name', 'value', 'isPrimary')

  createFormFromRelationship: (model, relationship, formArray) ->
    recordArray = model.get(relationship)

    unless recordArray.get('length')
      return formArray.pushObject Ember.Object.create
        isPrimary: true, name: 'work', value: ''

    recordArray.forEach (item) ->
      formArray.pushObject Ember.Object.create(
        isPrimary: item.get('isPrimary'), name: item.get('name'), value: item.get('value'), record: item)
