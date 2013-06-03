Radium.ChecklistItemController = Radium.ObjectController.extend
  isAdditional: ( ->
    @get('kind') == 'additional'
  ).property('kind')

  removeAdditionalItem: (item) ->
    item.get('forecast').removeObject item
