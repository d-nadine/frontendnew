Radium.DealsNewController = Ember.ObjectController.extend
  needs: ['contacts']
  contacts: Ember.computed.alias 'controllers.contacts'
  selectChecklistItem: (checklistItem) ->
    @set 'selectedCheckboxItem', checklistItem

  total: ( ->
    total = 0

    @get('checklist.checklistItems').forEach (item) ->
      total += item.get('weight') if item.get('isFinished')

    total
  ).property('checklist.checklistItems.@each.isFinished')

  toggleIsFinished: ->
    @toggleProperty 'selectedCheckboxItem.isFinished'
