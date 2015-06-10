require 'mixins/components/position_dropdown'

Radium.AssigntoPickerComponent = Ember.Component.extend Radium.PositionDropdownMixin,
  actions:
    assign: (model, user) ->
      model.set 'user', user

      parent = @get('parent')

      model.save().then (result) ->
        parent.send 'flashSuccess', "#{model.get('displayName')} has been assigned to #{user.get('displayName')}"

      return unless parent
      return unless parent._actions['completeAssignTo']

      parent.send "completeAssignTo", model, user

      false
