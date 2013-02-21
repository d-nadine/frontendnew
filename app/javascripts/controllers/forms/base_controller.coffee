Radium.FormsBaseController = Ember.ObjectController.extend Radium.CurrentUserMixin, Radium.FormsControllerMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')

