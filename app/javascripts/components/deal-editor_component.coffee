Radium.DealEditorComponent = Ember.Component.extend
  actions:
    cancel: ->
      @reset()

      @get('modal').send 'closeModal'

      false

    companyNameSelected: (company) ->
      return if @get('dealForm.name.length')

      companyName = company.get('name')

      dealName = @getDealName(companyName)

      @$('.validation-input-component').val(dealName)
      @set 'dealForm.name', dealName

      false

    contactSet: (contact) ->
      return if @get('dealForm.name.length')

      contactName = contact.get('displayName')

      dealName = @getDealName(contactName)

      @$('.validation-input-component').val(dealName)
      @set 'dealForm.name', dealName

      false

    submit: ->
      @set 'isSubmitted', true

      Ember.run.next =>
        return unless @get('formValid')

        dealForm = @get('dealForm')

        request = {}

        companyName = @get('dealForm.companyName')

        company = if $.isEmptyObject(@get('dealForm.company'))
                    null
                  else
                    @get('dealForm.company')

        if companyName || company
          if !company || companyName != company.name
            request.companyName = companyName
          else
            if id = company.id
              request.company = Radium.Company.all().find (c) -> c.get('id') == id
            else
              request.companyName = company.name
              request.companyLogo = company.logo
              request.companyWebsite = company.website

        request.name = @get('dealForm.name')

        deal = Radium.CreateDeal.createRecord request

        deal.save().then =>
          @send 'cancel'

      false

  getDealName: (name) ->
    existing = Radium.Deal.all().filter (d) -> d.get('name') == name

    dealName = if existing.length
                 "#{name} ##{(existing.length + 1)}"
               else
                 name

    name

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'modal', @nearestOfType(Radium.XModalComponent)

    dealForm =
      companyName: null
      company: {}
      contact: null
      name: null

    @set 'dealForm', dealForm

    Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

  _afterRender: ->
    @_super.apply this, arguments
    @$('input[type=text]:first').focus()

  reset: ->
    @set 'isSubmitted', false
    @set 'dealForm', null

  errorMessages: Ember.A()

  formValid: Ember.computed.equal 'errorMessages.length', 0

  dealNamePlaceholder: Ember.computed 'dealForm.contact', 'dealForm.company', ->
    "New #{@get('list.itemName')}"

  orFields: ['dealForm.companyName', 'dealForm.contact']
  orValidations: ['or']
  nameValidations: ['required']
  isSubmitted: false

  companyIsSet: Ember.computed.bool 'dealForm.companyName'
  contactIsSet: Ember.computed.bool 'dealForm.contact'
