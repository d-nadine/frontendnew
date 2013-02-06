Radium.SettingsMixin = Ember.Mixin.create
  needs: ['settings']

  settings: ( ->
    @get('controllers.settings')
  ).property('controllers.settings')
