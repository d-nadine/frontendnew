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
      return @send('stopEditing') unless companyName?.length

      @set('form.company', Ember.Object.create name: companyName)

      @send 'commit'

    setProperties: ->
      unless model = @get('model')
        return

      form = @get('form')

      if form.get('company.name') == model.get('company.name')
        return

      if Ember.isEmpty(form.get('company.name')) && @get('model.company.name')
        model.set 'removeCompany', true
        model.set 'company', null

      model.set('companyName', form.get('company.name'))

    commit: ->
      existing = $.trim(@get('model.company.name') || '')
      updated = $.trim(@get('form.company.name') || '')

      companyUpdate =  ((existing != updated) && updated != '')

      if company = @get('company')
        @set('existingCompany', company)

      @set('companyAdded', companyUpdate)

      args = if Ember.isEmpty(updated)
               [true]
             else
               []

      @_super.apply this, args

      false

    modelChanged: (company) ->
      @set 'form.company', 'company'
      @send 'commit'
  
  updateHook: (contact) ->
    if existingCompany = @get('existingCompany')
      existingCompany.reload()
      @set('existingCompany', null)

    return unless @get('companyAdded')

    @set 'companyAdded', false

    observer = ->
      if company =  contact.get('company')
        contact.removeObserver 'company', observer
        company.reload()

    contact.addObserver 'company', observer

  isValid: Ember.computed 'form.company',  'isEditing', ->
    true

  form: Ember.computed ->
    Radium.ContactCompanyForm.create()
