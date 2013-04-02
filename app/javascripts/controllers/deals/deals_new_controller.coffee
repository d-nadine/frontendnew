Radium.DealsNewController = Ember.ObjectController.extend
  needs: ['contacts','users', 'dealStatuses']
  contacts: Ember.computed.alias 'controllers.contacts'
  checklistItems: Ember.computed.alias 'checklist.checklistItems'
  statuses: Ember.computed.alias('controllers.dealStatuses.inOrder')

  total: ( ->
    total = 0

    @get('checklist.checklistItems').forEach (item) ->
      total += item.get('weight') if item.get('isFinished')

    additionalWeight = @get('additionalChecklistItem.weight')

    if /^\d+$/.test additionalWeight
      total += parseInt(additionalWeight)

    total = if total > 100 then 100 else total

    total
  ).property('checklist.checklistItems.@each.isFinished', 'additionalChecklistItem.weight')

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
