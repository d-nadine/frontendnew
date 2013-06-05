require 'controllers/sidebar/sidebar_base_controller'

Radium.CompanyWebsiteForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  properties: ['companyWebsite']

  reset: ->
    @_super.apply this, arguments
    @set 'companyWebsite', ''

Radium.SidebarCompanyWebsiteController = Radium.SidebarBaseController.extend
  isValid: true

  setForm: ->

  form: ( ->
    Radium.CompanyWebsiteForm.create()
  ).property()

