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
               description: "follow up"
               finishBy: date

      self = this

      todo.one 'didCreate', (result) ->
        self.send 'todoAdded', result

      @get('store').commit()

    todoAdded: (todo) ->
      contact = @get('model')

      observer = =>
        return unless todo.get('id')

        todo.removeObserver 'id', observer

        contact.updateLocalBelongsTo 'nextTodo', todo

        @$('.modal').modal('hide')

      if todo.get('id')
        observer()
      else
        todo.addObserver 'id', observer

    showTodoModal: ->
      @$('.modal').modal(backdrop: false)

  store: Ember.computed ->
    @get('container').lookup 'store:main'

  needs: ['users']

  setupCustom: ->
    @$('.mentions-input-box textarea').focus()

  setup: Ember.on 'didInsertElement', ->
    # $(window).on @get('eventNamespace'), @positionDropdown.bind(this)

    Ember.$('.modal').modal('hide')

    @$('.modal').on 'shown', @setupCustom.bind(this)

  teardown: Ember.on 'willDestroyElement', ->
    @$('.modal').off 'shown'

    # $(window).off @get('eventNamespace')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')

  isEditable: true
