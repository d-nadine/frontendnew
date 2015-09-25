Radium.CommonDrawerActions = Ember.Mixin.create
  actions:
    showContactDrawer: (contact, hideMain) ->
      @closeContactDrawer()

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

    closeContactDrawer: ->
      @closeContactDrawer()

      false

    closeCompanyDrawer: ->
      @closeCompanyDrawer()

      false

  showContactDrawer: false
  contactModel: null
  contactParams: null

  showCompanyDrawer: false
  companyModel: null
  companyParams: null

  closeContactDrawer: ->
    @set 'showContactDrawer', false
    @set 'contactModel', null
    @set 'contactParams', null

  closeCompanyDrawer: ->
    @set 'showCompanyDrawer', false
    @set 'companyModel', null
    @set 'companyParams', null
