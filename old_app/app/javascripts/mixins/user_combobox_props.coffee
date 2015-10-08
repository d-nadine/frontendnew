Radium.UserComboboxProps = Ember.Mixin.create
  users: Ember.computed.oneWay 'controllers.users'
  userValidations: ['required']
