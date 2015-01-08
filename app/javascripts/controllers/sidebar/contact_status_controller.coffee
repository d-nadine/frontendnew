require 'controllers/sidebar/sidebar_base_controller'

Radium.ContactStatusForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  properties: ['contactStatus']

  reset: ->
    @_super.apply this, arguments
    @set 'status', null

Radium.SidebarContactStatusController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.contactStatus', @get('model.contactStatus')

  needs: ['contactStatuses']
  isValid: true

  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'

  availableStatuses: Ember.computed 'contactStatus.[]', 'model.contactStatus', ->
    status = @get('model.contactStatus')
    contactStatuses = @get('contactStatuses') || []

    return contactStatuses unless status

    contactStatuses.reject (s) -> status == s

  form: Ember.computed ->
    Radium.ContactStatusForm.create()
