Radium.DealsNewController = Ember.ObjectController.extend
  needs: ['contacts','users', 'companies', 'dealStatuses', 'dealSources']
  contacts: Ember.computed.alias 'controllers.contacts'
  checklistItems: Ember.computed.alias 'checklist.checklistItems'
  statuses: Ember.computed.alias('controllers.dealStatuses.inOrder')
  newItemDescription: ''
  newItemWeight: 0

  saveAsDraft: ->
    @set 'isPublished', false
    @submit()

  publish: ->
    @set 'isPublished', true
    @submit()

  submit: ->
    @set 'isSubmitted', true
    return unless @get('isValid')

    @set 'justAdded', true

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false

      deal = @get('model').commit()
      @get('model').reset()

      @transitionToRoute 'deal', deal
    ), 1200)
