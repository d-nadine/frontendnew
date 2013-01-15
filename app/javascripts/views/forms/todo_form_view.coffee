Radium.TodoFormView = Ember.View.extend
  templateName: 'radium/todo_form'

  expandForm: ->
    @toggleProperty 'expanded'
