Radium.DealsChecklistItemController = Radium.ObjectController.extend
  needs: ['account']
  accountChecklist: Ember.computed 'controllers.account', 'controllers.account', ->
    workflow = @get('controllers.account.workflow')
    checklistItems = Ember.A()
    workflow.forEach (workflowItem) ->
      checklist = workflowItem.get('checklist')
      ret.pushObjects(checklist.toArray()) if checklist.get('length')

    checklistItems

  isAdditional: Ember.computed 'workflow.[]', 'model', ->
    accountChecklist = @get('accountChecklist')

    return true unless accountChecklist.get('length')

    current = @get('model')

    not accountChecklist.any (item) =>
      item.get('kind') == current.get('kind') && item.get('description') == current.get('description')
