Radium.AddCompanyComponent = Ember.Component.extend
  actions:
    createCompany: ->
      @set 'isSubmitted', true

      Ember.run.next =>
        return unless @get('formValid')

        companyHash = @get('companyForm.company')

        hash = unless $.isEmptyObject(companyHash)
                 companyHash
               else
                 name: @get('companyForm.companyName')

        company = Radium.Company.createRecord hash

        company.save().then((result) =>
          addressbookController = @get('addressbookController')
          addressbookController.send('updateTotals') if addressbookController

          addressbookCompaniesController = @get('addressbookCompaniesController')
          dataset = addressbookCompaniesController.get('model')

          dataset.insertAt 0, result

          addressbookCompaniesController.incrementProperty "totalRecords"

          @flashMessenger.success "#{@get('company.name')} created."
          @reset()
        ).finally =>
          @set('isSaving', false)

      false

    companyNameSelected: (company) ->
      if company.get('id')
        return @showExisting()

      false

    hideNewCompany: ->
      @$().slideUp 'slow', ->
        Ember.$('.address-book-controls').slideDown('medium')
        @reset()

    resetForm: ->
      @reset()

      false

  classNames: ['new-company', 'hide']

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    Ember.run.scheduleOnce 'afterRender', this, 'reset'

  showExisting: ->
    @$('.existing-company').slideDown('medium')
    @set('existingChosen', true)

  reset: ->
    companyForm =
      companyName: null
      company: {}

    @set 'companyForm', companyForm
    @set 'existingChosen', false
    @set 'isSubmitted', false
    @set 'isSaving', false

    el = @$('input[type=text]')

    el.val('')

    Ember.run.next ->
      el.focus()

  # UPGRADE: use inject after upgrade
  addressbookController: Ember.computed ->
    @container.lookup('controller:addressbook')

  addressbookCompaniesController: Ember.computed ->
    @container.lookup('controller:addressbookCompanies')

  isSubmitted: false
  isSaving: false

  errorMessages: Ember.A()
  companyValidations: ['required']
  existingChosen: false
  formValid: Ember.computed.equal 'errorMessages.length', 0
