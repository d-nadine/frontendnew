require 'mixins/components/position_dropdown'

Radium.StatusPickerComponent = Ember.Component.extend Radium.PositionDropdownMixin,
  actions:
    changeStatus: (contact, status) ->
      contact.set 'contactStatus', status

      parent = @get('targetObject.parentController')

      contact.save(parent).then (result) ->
        parent.send 'flashSuccess', 'Status added.'

  store: Ember.computed ->
    @get('store').lookup('store:main')
