Radium.FormsCompanyController = Radium.ObjectController.extend Ember.Evented,
  actions:
    createCompany: ->
      @set 'isSubmitted', true
      return unless @get('isValid')

      @set 'isSaving', true

      company = Radium.Company.createRecord
                  name: @get('companyName')

      company.one 'didCreate', (result) =>
        @send 'reset'
        @send 'flashSuccess', "#{@get('companyName')} created."
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

  init: ->
    @_super.apply this, arguments
    @get('controllers.addressbook').on('setupNewCompany', this, 'onSetupNewCompany')

  onSetupNewCompany: ->
    @send 'reset'

  isValid: ( ->
    @get('companyName.length')
  ).property('companyName.length', 'isSubmitted')
