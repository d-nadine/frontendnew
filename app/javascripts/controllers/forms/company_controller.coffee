Radium.FormsCompanyController = Radium.ObjectController.extend Ember.Evented,
  actions:
    createCompany: ->
      @set 'isSubmitted', true
      return unless @get('isValid')

      @set 'isSaving', true

      company = Radium.Company.createRecord
                  name: @get('companyName')

      company.one 'didCreate', (result) =>
        addressBook = @get('controllers.addressbook.content')
        addressBook.pushObject(company)

        @send 'flashSuccess', "#{@get('companyName')} created."
        @send 'reset'
        @transitionToRoute 'company', result

      company.one 'becameInvalid', (result) =>
        @set 'isSaving', false
        @send 'flashError', company
        result.reset()

      company.one 'becameError', (result)  =>
        @set 'isSaving', false
        @send 'flashError', 'An error has occurred and the company could not be created.'
        result.reset()

      @get('store').commit()

    reset: ->
      @set('isSaving', false)
      @set('companyName', '')
      @set('company', null)
      @set('isSubmitted', false)
      Ember.run.next =>
        @trigger 'setupNewCompany'

  needs: ['addressbook']
  companyName: ''
  company: null
  isSaving: false
  isSubmitted: false

  isDisabled: Ember.computed 'isSaving', 'company', ->
    return true if @get('isSaving') || @get('company')

  canFollow: Ember.computed 'model.user', 'currentUser', ->
    @get('model.user') != @get('currentUser')

  init: ->
    @_super.apply this, arguments
    @get('controllers.addressbook').on('setupNewCompany', this, 'onSetupNewCompany')

  onSetupNewCompany: ->
    @send 'reset'

  isValid: Ember.computed 'companyName.length', 'isSubmitted', ->
    @get('companyName.length')
