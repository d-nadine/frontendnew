Radium.ExtenalContactsItemController = Radium.ObjectController.extend
  isThumbnailsVisible: Ember.computed.alias 'parentController.isThumbnailsVisible'
  check: (item) ->
    item.toggleProperty 'isChecked'
