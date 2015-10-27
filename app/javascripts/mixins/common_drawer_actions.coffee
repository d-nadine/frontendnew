Radium.CommonDrawerActions = Ember.Mixin.create
  actions:

    showCompanyModal: (company, hideMain) ->
      company = if company.constructor == Radium.Company
                  company
                else
                  company.get('company')

      Ember.assert "You have passed a non company instance to showCompanyDrawer", company

      @closeCompanyDrawer()

      @set "companyModel", company

      config = {
        bindings: [{
          name: "company",
          value: "companyModel"
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "hideDeals",
          value: true,
          static: true
        },
        {
          name: "deleteCompany",
          value: "deleteCompany",
          static: true
        },
        {
          name: "chop",
          value: true,
          static: true
        },
        {
          name: "noscroll",
          value: true,
          static: true
        }
        ],
        component: 'company-sidebar'
      }

      @set 'companyParams', config

      @set 'showCompanyModal', true

      false

    showContactModal: (contact) ->
      @send "closeContactDrawer"

      Ember.assert "You have passed a non contact instance to showContactDrawer", contact.constructor == Radium.Contact

      @set 'contactModel', contact

      config = {
        bindings: [{
          name: "contact",
          value: "contactModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeContactDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "addList",
          value: "addContactList",
          static: true
        },
        {
          name: "customFields",
          value: "customFields"
        },
        {
          name: "deleteContact",
          value: "deleteContact",
          static: true
        },
        {
          name: "chop",
          value: true,
          static: true
        },
        {
          name: "noscroll",
          value: true,
          static: true
        }
        ]
        component: 'contact-sidebar'
      }

      Ember.run.next =>
        @set 'contactParams', config

        @set 'showContactModal', true

        false

    showContactDrawer: (contact, hideMain) ->
      @closeContactDrawer()

      Ember.assert "You have passed a non contact instance to showContactDrawer", contact.constructor == Radium.Contact

      @set 'contactModel', contact

      config = {
        bindings: [{
          name: "contact",
          value: "contactModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeContactDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "addList",
          value: "addContactList",
          static: true
        },
        {
          name: "customFields",
          value: "customFields"
        },
        {
          name: "deleteContact",
          value: "deleteContact",
          static: true
        },
        {
          name: "hideMain",
          value: hideMain,
          static: true
        }
        ]
        component: 'x-contact'
      }

      Ember.run.next =>
        @set 'contactParams', config

        @set 'showContactDrawer', true

        false

    showCompanyDrawer: (company, hideMain) ->
      company = if company.constructor == Radium.Company
                  company
                else
                  company.get('company')

      Ember.assert "You have passed a non company instance to showCompanyDrawer", company

      @closeCompanyDrawer()

      @set "companyModel", company

      config = {
        bindings: [{
          name: "company",
          value: "companyModel"
        },
        {
          name: "closeDrawer",
          value: "closeDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "hideDeals",
          value: true,
          static: true
        },
        {
          name: "deleteCompany",
          value: "deleteCompany",
          static: true
        },
        {
          name: "hideMain",
          value: hideMain,
          static: true
        }
        ],
        component: 'x-company'
      }

      @set 'companyParams', config

      @set 'showCompanyDrawer', true

      false

    showDealDrawer: (deal, hideMain) ->
      @closeDealDrawer()

      Ember.assert "You have passed a non deal instance to showDealDrawer", deal.constructor == Radium.Deal

      @set 'dealModel', deal

      config = {
        bindings: [{
          name: "deal",
          value: "dealModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeContactDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "showContactModal",
          value: "showContactModal",
          static: true
        },
        {
          name: "showCompanyModal",
          value: "showCompanyModal",
          static: true
        }
        {
          name: "showCompanyDrawer",
          value: "showCompanyDrawer",
          static: true
        },
        {
          name: "hideMain",
          value: hideMain,
          static: true
        }
        ]
        component: 'x-deal'
      }

      @set 'dealParams', config

      @set 'showDealDrawer', true

      false

    closeDealDrawer: ->
      @closeDealDrawer()

      false

    closeContactDrawer: ->
      @closeContactDrawer()

      false

    closeContactModal: ->
      @closeContactModal()

      false

    closeCompanyModal: ->
      @closeCompanyModal()

    closeCompanyDrawer: ->
      @closeCompanyDrawer()

      false

  showContactDrawer: false
  contactModel: null
  contactParams: null

  showCompanyDrawer: false
  companyModel: null
  companyParams: null

  showDealDrawer: false
  dealModel: null
  dealParams: null

  closeContactModal: ->
    return if @isDestroyed || @isDestroying
    @set 'showContactModal', false
    @set 'contactModel', null
    @set 'contactParams', null

  closeCompanyModal: ->
    return if @isDestroyed || @isDestroying
    @set 'showCompanyModal', false
    @set 'contactModel', null
    @set 'contactParams', null

  closeContactDrawer: ->
    return if @isDestroyed || @isDestroying
    @set 'showContactDrawer', false
    @set 'contactModel', null
    @set 'contactParams', null

  closeCompanyDrawer: ->
    return if @isDestroyed || @isDestroying
    @set 'showCompanyDrawer', false
    @set 'companyModel', null
    @set 'companyParams', null

  closeDealDrawer: ->
    return if @isDestroyed || @isDestroying
    @set 'showDealDrawer', false
    @set 'dealModel', null
    @set 'dealParams', null

  closeAllDrawers: ->
    return if @isDestroyed || @isDestroying
    @closeDealDrawer()
    @closeContactDrawer()
    @closeCompanyDrawer()
