Radium.DealsNewController = Radium.DealBaseController.extend Radium.ChecklistMixin,
  Radium.AttachedFilesMixin,
  actions:
    submit: ->
      @set 'isSubmitted', true
      return unless @get('model.isValid')

      deal = @get('model').create()

      deal.one 'didCreate', =>
        Ember.run.next =>
          @set 'isSaving', false
          @transitionToRoute 'deal', deal

      deal.one 'becameInvalid', (result) =>
        @set 'isSaving', false
        error = deal.get('errors.error')

        if new RegExp('\\b' + @get('plan') + '\\b').test(error)
          @set 'error', error
        else
          @send 'flashError', deal

        deal.deleteRecord()

      deal.one 'becameError', (result)  ->
        @set 'isSaving', false
        @send 'flashError', 'An error has occurred and the deal could not be created.'
        deal.deleteRecord()

      @set 'isSaving', true

      @get('store').commit()

    saveAsDraft: ->
      @set 'status', 'unpublished'
      @set 'isPublished', false
      @send 'submit'

    publish: ->
      @set 'isPublished', true
      @send 'submit'

  needs: ['contacts','users', 'accountSettings']
  statuses: Ember.computed.alias('controllers.accountSettings.workflowStates')

  contacts: Ember.computed 'controllers.contacts.[]', ->
    @get('controllers.contacts').filter (contact) ->
      contact.get('status') != 'personal'

  error: null

  checklist: Ember.computed 'status', ->
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

  statusesDidChange: Ember.computed 'statuses.[]', ->
    return unless @get('statuses.length')
    return if @get('status')

    @set('status', @get('statuses.firstObject'))
