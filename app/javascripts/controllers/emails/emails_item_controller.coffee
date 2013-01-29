Radium.EmailsItemController = Em.ObjectController.extend
  showActions: false

  showActionSection: ->
    @toggleProperty('showActions')
