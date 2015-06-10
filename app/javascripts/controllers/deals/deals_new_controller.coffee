require 'mixins/user_combobox_props'

Radium.DealsNewController = Radium.DealBaseController.extend Radium.ChecklistMixin,
  Radium.AttachedFilesMixin,
  Radium.UserComboboxProps,
  actions:
    submit: ->
      @set 'isSubmitted', true
      return unless @get('isValid')

      @set 'isSaving', true

      deal = @get('model').create()

      self = this

      deal.save().then((result) =>
        Ember.run.next =>
          @set 'isSaving', false
          @transitionToRoute 'deal', deal
      ).catch (result) ->
        self.set 'isSaving', false

    saveAsDraft: ->
      @set 'status', 'unpublished'
      @set 'isPublished', false
      @send 'submit'

    publish: ->
      @set 'isPublished', true
      @send 'submit'

  needs: ['contacts','users', 'accountSettings']

  statuses: Ember.computed.oneWay('controllers.accountSettings.workflowStates')

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

    checklist.pushObjects selectedChecklist.map (checkListItem) ->
                                                Ember.Object.create checkListItem.serialize()

    checklist

  statusesDidChange: Ember.computed 'statuses.[]', ->
    return unless @get('statuses.length')
    return if @get('status')

    @set('status', @get('statuses.firstObject'))

  contactInvalid: Ember.computed 'isSubmitted', 'contact', ->
    @get('isSubmitted') && !@get('contact')

  isValid: Ember.computed 'name', 'contact', 'user', 'source', 'description', 'value', ->
    return false if Ember.isEmpty(@get('name'))
    return false if Ember.isEmpty(@get('contact'))
    return false if Ember.isEmpty(@get('user'))
    return false if Ember.isEmpty(@get('description'))

    dealValue = accounting.unformat @get('value')

    return false if Ember.isEmpty(dealValue)
    return false if parseInt(dealValue) == 0

    true

  contactValidations: ['required']
