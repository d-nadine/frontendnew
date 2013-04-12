Radium.FormView = Ember.View.extend
  didInsertElement: ->
    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on
