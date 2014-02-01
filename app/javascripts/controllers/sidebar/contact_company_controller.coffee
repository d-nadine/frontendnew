require 'controllers/sidebar/sidebar_base_controller'

Radium.ContactCompanyForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  reset: ->
    @_super.apply this, arguments
    @set 'company', null


Radium.SidebarContactCompanyController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.company', @get('model.company')

    createCompany: (companyName) ->
      @set('form.company', Ember.Object.create name: companyName)
      @send 'commit'
      @send 'stopEditing'

    setProperties: ->
      unless model = @get('model')
        return

      form = @get('form')

      if form.get('company.name') == model.get('company.name')
        return

      if Ember.isEmpty(form.get('company.name'))
        model.set 'company', null

      model.set('companyName', form.get('company.name'))

    commit: ->
      @_super.apply this, arguments
      @get('model').notifyPropertyChange('company')

  isValid: ( ->
    # return unless @get('isEditing')
    # return if Ember.isEmpty @get('form.contact')
    true
  ).property('form.company',  'isEditing')

  form: ( ->
    Radium.ContactCompanyForm.create()
  ).property()
