require 'controllers/sidebar/sidebar_base_controller'

Radium.DealStatusForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  properties: ['status']

  reset: ->
    @_super.apply this, arguments
    @set 'status', null

Radium.SidebarDealStatusController = Radium.SidebarBaseController.extend
  needs: ['accountSettings']
  statuses: Ember.computed.alias('controllers.accountSettings.workflowStates')
  isValid: true

  setForm: ->
    @set 'form.status', @get('model.status')

  form: ( ->
    Radium.DealStatusForm.create()
  ).property()
