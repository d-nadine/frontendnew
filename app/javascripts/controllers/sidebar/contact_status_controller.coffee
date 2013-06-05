require 'controllers/sidebar/sidebar_base_controller'

Radium.ContactStatusForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  properties: ['status']

  reset: ->
    @_super.apply this, arguments
    @set 'status', null

Radium.SidebarContactStatusController = Radium.SidebarBaseController.extend
  needs: ['leadStatuses']
  isValid: true

  setForm: ->
    @set 'form.status', @get('model.status')

  form: ( ->
    Radium.ContactStatusForm.create()
  ).property()
