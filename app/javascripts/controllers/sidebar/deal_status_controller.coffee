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
  actions:
    setProperties: ->
      if @get('isLost')
        @set 'form.lostDuring', @get('model.status')
      else
        @set 'form.lostBecause', null
        @set 'form.lostDuring', null

      @_super.apply this, arguments

    commit: ->
      if @get('model.status') == @get('form.status')
        @set 'isEditing', false
        return

      # FIXME: likely to break in the next upgrade when
      # this __nextSuper ember confusion goes away
      # should be _super but ember broke that
      @send 'showStatusChangeConfirm', this, @__nextSuper

    setForm: ->
      @set 'form.status', @get('model.status')
      @set 'lostBecause', null

  needs: ['accountSettings','pipeline']
  statuses: Ember.computed.alias('controllers.pipeline.dealStates')
  isValid: true

  isLost: ( ->
    return unless @get('form.status')
    @get('form.status').toLowerCase() == 'lost'
  ).property('form.status')

  form: ( ->
    Radium.DealStatusForm.create()
  ).property()
