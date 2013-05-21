require 'lib/radium/show_more_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  Radium.CheckableMixin,

  filters: [
    {name: 'all', text: 'All'}
    {name: 'people', text: 'People'}
    {name: 'assigned', text: 'Assigned To'}
    {name: 'lead', text: 'Lead'}
    {name: 'existing', text: 'Existing Customers'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Tags'}
  ]

  hasCheckedContent: Ember.computed.bool 'checkedContent.length'
  activeForm: null

  showTodoForm: Ember.computed.equal('activeForm', 'todo')
  showCallForm: Ember.computed.equal('activeForm', 'call')
  showEmailForm: Ember.computed.equal('activeForm', 'email')

  hasActiveForm: Ember.computed.notEmpty('activeForm')

  todoForm: Radium.computed.newForm('todo')

  showFormArea: ( ->
    @get('hasCheckedContent') && @get('hasActiveForm')
  ).property('hasCheckedContent', 'hasActiveForm')

  todoFormDefaults: (->
    description: null
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('checkedContent')
  ).property('checkedContent.[]', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    description: null
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    reference: @get('model')
  ).property('model.[]', 'tomorrow')

  showForm: (form) ->
    @set 'activeForm', form

  checkAll: ->
    @get('visibleContent').setEach 'isChecked', !@get('hasCheckedContent')

  changeFilter: (filter) ->
    @set('currentPage', 1)
    @set 'model.selectedFilter', filter
