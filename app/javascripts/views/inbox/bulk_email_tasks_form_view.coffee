require 'radium/views/forms/tasks_view'

Radium.BulkEmailTasksFormView = Radium.TasksView.extend
  init: ->
    @_super.apply this, arguments
    @get('buttons').insertAt 0,
      Ember.Object.create
       action: "delete"
       label: "Delete"
       alwaysOpen: true

  deleteAction: (e) ->
    @get('controller').deleteEmails()

  toggleTodoForm: (e) ->
    tasksContainer = @get('tasksContainer')
    todoFormView = Radium.TodoFormView.create(Radium.Slider,
      close: ->
        @get('parentView.parentView').closeForm()
      controller: Radium.TodoFormController.create
        kind: 'email'
        submit: ->
          selectedMail = todoFormView.get('parentView.controller.selectedMail')

          return unless selectedMail.get('.length')

          selectedMail.forEach (email) =>
            todo = Radium.Todo.createRecord
              kind: @get('kind')
              finishBy: @get('finishBy')
              user: Radium.get('router.currentUser')
              description: @get('description')

            todo.set('reference', email)

          Radium.get('router.store').commit()

          Radium.Utils.notify('Todos created!')
    )

    tasksContainer.set 'currentView', todoFormView
