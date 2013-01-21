require 'radium/views/forms/form_widget'

Radium.BulkActionFormWidget = Radium.FormWidgetView.extend
  init: ->
    @_super.apply this, arguments

    @get('buttons').insertAt 0,
      Ember.Object.create
       action: "delete"
       label: "Delete"
       alwaysOpen: true
       classes: 'btn btn-danger'
       icons: 'icon-trash icon-large icon-white'

  deleteAction: (e) ->
    @get('controller').deleteAll()

  todoController: ( ->
    Radium.TodoFormController.extend()
  ).property()

  destroy: ->
    buttons = @get('buttons')
    buttons.removeObject buttons.get('firstObject')
    @_super.apply this, arguments
