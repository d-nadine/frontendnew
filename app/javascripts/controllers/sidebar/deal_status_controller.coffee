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
  needs: ['accountSettings','pipeline']
  statuses: Ember.computed.alias('controllers.pipeline.workflowStates')
  isValid: true

  isLost: ( ->
    return unless @get('form.status')
    @get('form.status').toLowerCase() == 'lost'
  ).property('form.status')

  commit: ->
    if @get('model.status') == @get('form.status')
      @set 'isEditing', false
      return

    @send 'showStatusChangeConfirm', this, @_super

  setForm: ->
    @set 'form.status', @get('model.status')

  form: ( ->
    Radium.DealStatusForm.create()
  ).property()
