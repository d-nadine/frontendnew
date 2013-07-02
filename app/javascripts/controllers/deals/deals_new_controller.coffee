Radium.DealsNewController = Radium.ObjectController.extend Radium.ChecklistMixin,
  needs: ['contacts','users', 'accountSettings']
  statuses: Ember.computed.alias('controllers.accountSettings.workflowStates')
  pipelineStateChecklists: Ember.computed.alias('controllers.accountSettings.pipelineStateChecklists')
  newItemDescription: ''
  newItemWeight: null
  newItemFinished: true
  newItemDate: 0
  newItemKind: 'todo'
  hasContact: Ember.computed.bool 'contact'

  contacts: ( ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'
  ).property('controllers.contacts.[]')

  checklist: ( ->
    selectedChecklist = @get('pipelineStateChecklists').get(@get('status').toLowerCase())
    checklist = @get('model.checklist')
    checklist.clear()

    checklist.pushObjects selectedChecklist.map (checkListItem) =>
                                                Ember.Object.create checkListItem.serialize()

    checklist
  ).property('status')

  statusesDidChange: ( ->
    return unless @get('statuses.length')
    return if @get('status')

    @set('status', @get('statuses.firstObject'))
  ).observes('statuses.[]')

  saveAsDraft: ->
    @set 'status', 'unpublished'
    @set 'isPublished', false
    @submit()

  publish: ->
    @set 'isPublished', true
    @submit()

  submit: ->
    @set 'isSubmitted', true
    return unless @get('isValid')

    deal = @get('model').create()

    deal.one 'didCreate', =>
      Ember.run.next =>
        @transitionToRoute 'deal', deal

    deal.one 'becameInvalid', (result) =>
      Radium.Utils.generateErrorSummary deal

    deal.one 'becameError', (result)  ->
      Radium.Utils.notifyError 'An error has occurred and the deal could not be created.'

    @get('store').commit()

  removeAdditionalItem: (item) ->
    @get('checklist').removeObject item
