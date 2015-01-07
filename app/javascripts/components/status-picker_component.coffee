Radium.StatusPickerComponent = Ember.Component.extend
  actions:
    changeStatus: (contact, status) ->
      contact.set 'contactStatus', status

      parent = @get('targetObject.parentController')

      contact.save(parent).then (result) ->
        parent.send 'flashSuccess', 'Status added.'

  classNames: ['btn-group']

  store: Ember.computed ->
    @get('store').lookup('store:main')