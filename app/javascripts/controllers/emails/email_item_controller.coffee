Radium.EmailItemController = Em.ObjectController.extend
  showActions: false
  showActionSection: ->
    @toggleProperty 'showActions'
