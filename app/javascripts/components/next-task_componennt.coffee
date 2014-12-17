Radium.NextTaskComponent = Ember.Component.extend
  actions:
    addTodo: (period) ->
      p period

    showTodoModal: ->
      @$('.modal').modal(backdrop: false)

  classNames: ["dd", "dropdown"]

  needs: ['users']

  setupCustom: ->
    p "setup"

  setup: Ember.on 'didInsertElement', ->
    Ember.$('.modal').modal('hide')
 
    @$('.modal').on 'shown', @setupCustom.bind(this)

  teardown: Ember.on 'willDestroyElement', ->
    @$('.modal').off 'shown'

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')

  isEditable: true
