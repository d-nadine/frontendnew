require 'controllers/sidebar/sidebar_base_controller'

Radium.DealStatusForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  properties: ['status', 'lostBecause', 'lostDuring']

  reset: ->
    @_super.apply this, arguments
    @set 'status', null
    @set 'lostBecause', null
    @set 'lostDuring', null

Radium.SidebarDealStatusController = Radium.SidebarBaseController.extend
  needs: ['accountSettings','pipeline']
  statuses: Ember.computed.alias('controllers.pipeline.workflowStates')
  isValid: true

  isLost: ( ->
    return unless @get('form.status')
    @get('form.status').toLowerCase() == 'lost'
  ).property('form.status')

  setProperties: ->
    if @get('isLost') && @get('model.isDirty')
      @set 'form.lostDuring', @get('model.status')
    else
      @set 'form.lostBecause', null
      @set 'form.lostDuring', null

    @_super.apply this, arguments

  commit: ->
    if @get('model.status') == @get('form.status')
      @set 'isEditing', false
      return

    @send 'showStatusChangeConfirm', this, @_super

  setForm: ->
    @set 'form.status', @get('model.status')
    @set 'lostBecause', null

  form: ( ->
    Radium.DealStatusForm.create()
  ).property()
