require 'mixins/components/position_dropdown'

Radium.StatusPickerComponent = Ember.Component.extend Radium.PositionDropdownMixin,
  actions:
    changeStatus: (contact, status) ->
      contact.set 'contactStatus', status

      contact.save().then (result) =>
        @flashMessenger.success 'Status added.'
