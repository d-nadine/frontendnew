Radium.SaveContactActions = Ember.Mixin.create
  actions:
    saveCompany: (context) ->
      if Ember.isEmpty(context.get('bufferedProxy.companyName')) && context.get('model.company')
        context.set('bufferedProxy.removeCompany', true)
        context.set('bufferedProxy.company', null)

      model = context.get('model')

      model.one 'didReload', (result) =>
        unless company = model.get('company')
          return

        @get('addressbook').send 'updateTotals'
        company.reload()

      false

  # UPGRADE: replace with inject
  addressbook: Ember.computed ->
    @container.lookup 'controller:addressbook'
