Radium.AccountMixin = Ember.Mixin.create
  needs: ['settings']

  settings: ( ->
    @get('controllers.settings')
  ).property('controllers.settings')
