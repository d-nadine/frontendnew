require 'mixins/components/position_dropdown'

Radium.AssigntoPickerComponent = Ember.Component.extend Radium.PositionDropdownMixin,
  actions:
    assign: (model, user) ->
      model.set 'user', user

      model.one 'didUpdate', =>
        @send 'flashSuccess', "#{model.get('displayName')} has been assigned to #{user.get('displayName')}"

      model.one 'becameInvalid', =>
        @send 'flashError', model

      model.one 'bemameError', =>
        @send 'an error has occurred and the assignment was not completed'

      @get('store').commit()
      false

  store: Ember.computed ->
    @get('container').lookup('store:main')
