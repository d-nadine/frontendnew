require 'controllers/sidebar/sidebar_base_controller'

Radium.CompanyWebsiteForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  properties: ['website']

  reset: ->
    @_super.apply this, arguments
    @set 'website', ''

Radium.SidebarCompanyWebsiteController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set('form.website', @get('website'))

  isValid: true

  form: ( ->
    Radium.CompanyWebsiteForm.create()
  ).property()

