require 'radium/views/forms/bulk_action_form_widget'
Radium.BulkPipelineFormWidget = Radium.BulkActionFormWidget.extend
  init: ->
    @_super.apply this, arguments
    buttons = @get('buttons')

    deleteButton = buttons.shift()

    buttons.insertAt 0,
      Ember.Object.create
       action: "assign"
       label: "Assign"
       closed: true

    buttons.removeAt(2)

    buttons.push(
      Ember.Object.create
       action: "email"
       label: "Email"
       closed: true
    )

    buttons.push(
      Ember.Object.create
       action: "changeStatus"
       label: "Change Status"
       alwaysOpen: true
       classes: 'btn'
    )

    buttons.push(deleteButton)

  additionalText: ( ->
    "(#{@get('selection.length')})"
  ).property('selection', 'selection.length')

  assignView: ( ->
    Radium.UnimplementedView.extend()
  ).property()

  emailView: ( ->
    Radium.UnimplementedView.extend()
  ).property()

