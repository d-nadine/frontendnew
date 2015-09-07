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
      dealForm = @get('dealForm')

      dealForm.setProperties
        companyName: null
        company: null
        contactName: null
        contact: contact

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

        if contact = dealForm.contact
          if typeof contact == "string"
            request.contactName = contact
          else
            request.contact = contact

        request.name = @get('dealForm.name')

        request.list = @get('list')

        deal = Radium.CreateDeal.createRecord request

        deal.save().then( =>
          @flashMessenger.success "The new #{@get('list.itemName')} has been created."
          @send 'cancel'
        ).finally =>
          @set 'isSubmitted', false

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

    Ember.assert "You must supply a list to the deal editor component.", @get('list')

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