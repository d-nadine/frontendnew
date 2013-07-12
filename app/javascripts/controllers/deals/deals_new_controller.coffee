Radium.DealsNewController = Radium.DealBaseController.extend Radium.ChecklistMixin,
  needs: ['contacts','users', 'accountSettings']
  statuses: Ember.computed.alias('controllers.accountSettings.workflowStates')
  contacts: ( ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'
  ).property('controllers.contacts.[]')

  checklist: ( ->
    status = @get('status').toLowerCase()

    Ember.assert("No pipeline state checklists exist", !!@get('pipelineStateChecklists.length'))

    selectedChecklist = if status == 'unpublished'
                          @get('pipelineStateChecklists').get(@get('statuses.firstObject').toLowerCase())
                        else
                          @get('pipelineStateChecklists').get(status)

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
        @set 'isSaving', false
        @transitionToRoute 'deal', deal

    deal.one 'becameInvalid', (result) =>
      @set 'isSaving', false
      Radium.Utils.generateErrorSummary deal

    deal.one 'becameError', (result)  ->
      @set 'isSaving', false
      Radium.Utils.notifyError 'An error has occurred and the deal could not be created.'

    @set 'isSaving', true

    @get('store').commit()

  removeAdditionalItem: (item) ->
    @get('checklist').removeObject item
