Radium.SettingsConfirmPipelineStateDeletionController = Radium.ObjectController.extend
  needs: ['accountSettings']
  accountSettings: Ember.computed.alias 'controllers.accountSettings'
  selectedOtherState: null
  isUpdatingDeals: false

  hasDeals: Ember.computed 'model', 'isUpdatingDeals', ->
    deals = Radium.Deal.all()

    return false unless deals.get('length')

    deals.some (deal) =>
      deal.get('status') == @get('model.name')

  otherStates: Ember.computed 'accountSettings.workflowStates.[]', 'hasDeals', 'isUpdatingDeals', ->
    @get('accountSettings.workflowStates').reject (item) =>
                                        item == @get('model.name')

  transferDeals: ->
    deals = Radium.Deal.all().filter (deal) => deal.get('status') == @get('model.name')

    @set('isUpdatingDeals', true)

    transaction = @get('store').transaction()

    deals.forEach (deal) =>
      deal.set('status', @get('selectedOtherState'))

      transaction.add deal

      deal.one 'didUpdate', =>
        if deal == deals.get('lastObject')
          @set 'isUpdatingDeals', false

      deal.one 'becameInvalid', (result) =>
        transaction.rollback()
        @send 'flashError', result

      deal.one 'becameError', (result)  ->
        transaction.rollback()
        @send 'flashError', 'An error has occurred and the selected deals status could not be changed.'

    transaction.commit()
