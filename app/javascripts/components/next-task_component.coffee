Radium.NextTaskComponent = Ember.Component.extend
  actions:
    addTodo: (period) ->
      user = @get('currentUser')

      now = Ember.DateTime.create()

      switch period
        when "tomorrow" then date = now.atEndOfTomorrow()
        when "nextweek" then date = now.atEndOfWeek().advance(day: 1).atEndOfWeek().advance(day: 1)
        when "nextmonth" then date = now.nextMonth()

      todo = Radium.Todo.createRecord
               user: user
               reference: @get('model')
               description: "Follow-up"
               finishBy: date

      self = this

      todo.save().then (result) ->
        self.send 'todoAdded', result

      false

    todoAdded: (todo) ->
      model = @get('model')

      next = ->
        model.updateLocalBelongsTo('nextTodo', todo)
        model.updateLocalProperty('nextTaskDate', todo.get('time'))

      model.executeWhenInCleanState next

      false

    showTodoModal: ->
      @$('.modal').modal(backdrop: false)

      Ember.run.next ->
        modal = @$('.todo-modal')

        finished = ->
          textarea = @$('.todo-modal.fade.in textarea:first')

          textarea.focus()

        Radium.Common.wait modal.hasClass('in'), finished

  needs: ['users']

  setupCustom: ->
    @$('.mentions-input-box textarea').focus()

  setup: Ember.on 'didInsertElement', ->
    Ember.$('.modal').modal('hide')

    @$('.modal').on 'shown', @setupCustom.bind(this)

  teardown: Ember.on 'willDestroyElement', ->
    @$('.modal').off 'shown'

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    self = this
    reference: @get('model')
    finishBy: null
    user: @get('currentUser')
    modal: true
    closeFunc: ->
      self.$('.modal').modal('hide')
