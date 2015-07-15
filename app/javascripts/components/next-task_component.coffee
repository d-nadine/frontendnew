require 'mixins/components/position_dropdown'

Radium.NextTaskComponent = Ember.Component.extend Radium.PositionDropdownMixin,
  actions:
    addTodo: (period) ->
      user = @get('currentUser')

      now = Ember.DateTime.create()

      switch period
        when "tomorrow" then date = @get('tomorrow')
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

    todoAdded: (todo) ->
      contact = @get('model')

      contact.reload()

    showTodoModal: ->
      @$('.modal').modal(backdrop: false)

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

  isEditable: true
