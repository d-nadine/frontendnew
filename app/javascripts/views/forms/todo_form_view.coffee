Radium.TodoFormView = Ember.View.extend
  templateName: 'radium/todo_form'

  expandForm: ->
    @toggleProperty 'expanded'

  optionsLabel: (->
    if @get('expanded') then 'hide' else 'options'
  ).property('expanded')
