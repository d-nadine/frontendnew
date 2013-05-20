Radium.AddressBookResultItemController = Radium.ObjectController.extend
  check: (item) ->
    item.toggleProperty 'isChecked'
