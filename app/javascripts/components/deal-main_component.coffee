Radium.DealMainComponent = Ember.Component.extend Radium.ScrollableMixin,
  actions:
    deleteDeal: ->
      @sendAction "deleteDeal", @get('deal')

      false
      

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      noteForm: @get('noteForm')
      about: @get('deal')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'deal', 'tomorrow', ->
    reference: @get('deal')
    finishBy: null
    user: @get('currentUser')

  noteForm: Radium.computed.newForm 'note'

  noteFormDefaults: Ember.computed 'deal', ->
    reference: @get('deal')
    user: @get('currentUser')

  loadedPages: [1]
