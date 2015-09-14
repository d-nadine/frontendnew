Radium.SaveContactActions = Ember.Mixin.create
  actions:
    saveCompany: (context) ->
      if Ember.isEmpty(context.get('bufferedProxy.companyName')) && context.get('model.company')
        context.set('bufferedProxy.removeCompany', true)
        context.set('bufferedProxy.company', null)

      false

    afterSaveCompany: ->
      @get('addressbook').send 'updateTotals'

      false

  # UPGRADE: replace with inject
  addressbook: Ember.computed ->
    @container.lookup 'controller:addressbook'
