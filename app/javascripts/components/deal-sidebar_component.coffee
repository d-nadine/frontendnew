require 'mixins/set_primary_contact'

Radium.DealSidebarComponent = Ember.Component.extend Radium.SetPrimaryContactMixin,
  Radium.ScrollableMixin,
  actions:
    saveCompany: (company) ->
      deal = @get('deal')
      eventBus = @EventBus

      saveDeal = (company) ->
        finish = ->
          eventBus.publishModelUpdate deal
          eventBus.publish 'rerender-company'

        if deal.get('list.companiesList')
          deal.set('company', company)

          deal.save().then finish
        else
          return unless contact = deal.get('contact')

          contact.set 'companyName', company.get('name')

          contact.save().then finish

      if company.get('id')
        deal.reset()

        company = Radium.Company.all().find (c) -> c.get('id') == company.id

        saveDeal(company)
        return false

      if company.get('isNewCompany') || !deal.get('company')
        company = Radium.Company.createRecord
          name: company.name
          logo: company.logo
          website: company.website

        company.save().then (result) ->
          saveDeal(result)

          return

      false

    showContactModal: (resource) ->
      contact = if resource.constructor == Radium.Contact
                  resource
                else
                  resource.get('contact')

        @sendAction "showContactModal", contact

      false

    showCompanyModal: (resource) ->
      company = if c = resource.get('company')
                  c
                else
                  resource

      @sendAction "showCompanyModal", company

      false

    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

  company: Ember.computed 'deal.list.type', 'deal.company', 'deal.contact.company', ->
    if @get('deal.list.companiesList')
      @get('deal.company')
    else
      @get('deal.contact.company')

  classNameBindings: [':form']

  # UPGRADE: replace with inject
  users: Ember.computed ->
    @container.lookup('controller:users')

  contactValidations: ['required']
