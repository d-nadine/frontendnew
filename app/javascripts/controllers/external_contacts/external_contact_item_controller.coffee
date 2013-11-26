Radium.ExtenalContactsItemController = Radium.ObjectController.extend
  check: (item) ->
    item.toggleProperty 'isChecked'
