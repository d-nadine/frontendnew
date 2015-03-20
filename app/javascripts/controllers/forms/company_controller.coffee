Radium.FormsCompanyController = Radium.ObjectController.extend Ember.Evented,
  Radium.CanFollowMixin,
  actions:
    createCompany: ->
      @set 'isSubmitted', true
      return unless @get('isValid')

      @set 'isSaving', true

      company = Radium.Company.createRecord
                  name: @get('companyName')

      company.one 'didCreate', (result) =>
        addressbookController = @get('controllers.addressbook')
        addressbookController.send('updateTotals') if addressbookController

        dataset = @get('controllers.addressbookCompanies.model')

        dataset.insertAt 0, result

        @send 'flashSuccess', "#{@get('companyName')} created."
        @trigger('formReset')

      company.one 'becameInvalid', (result) =>
        @set 'isSaving', false
        @send 'flashError', company
        result.reset()

      company.one 'becameError', (result)  =>
        @set 'isSaving', false
        @send 'flashError', 'An error has occurred and the company could not be created.'
        result.reset()

      @get('store').commit()

    modelChanged: (company) ->
      @set 'company', company
      @trigger 'modelChanged'

    reset: ->
      @set('isSaving', false)
      @set('companyName', '')
      @set('company', null)
      @set('isSubmitted', false)
      Ember.run.next =>
        @trigger 'setupNewCompany'

  needs: ['addressbook', 'addressbookCompanies']
  companyName: ''
  company: null
  isSaving: false
  isSubmitted: false

  isDisabled: Ember.computed 'isSaving', 'company', ->
    return true if @get('isSaving') || @get('company')

  init: ->
    @_super.apply this, arguments
    @get('controllers.addressbook').on('setupNewCompany', this, 'onSetupNewCompany')

  onSetupNewCompany: ->
    @send 'reset'

  isValid: Ember.computed 'companyName.length', 'isSubmitted', ->
    @get('companyName.length')

  companyValidations: ['required']
