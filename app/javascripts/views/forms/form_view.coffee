Radium.FormView = Ember.View.extend
  layoutName: 'layouts/form'

  didInsertElement: ->
    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on
