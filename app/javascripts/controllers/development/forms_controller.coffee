Radium.DevelopmentFormsController = Ember.Controller.extend
  toggleSwitch: ->
    @toggleProperty 'switchEnabled'
