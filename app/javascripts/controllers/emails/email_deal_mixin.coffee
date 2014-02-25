Radium.EmailDealMixin = Ember.Mixin.create
  actions:
    clearDeal: ->
      @set 'showingAddDeal', false
      @set 'deal', null

      return if @get('isNew')

      @get('store').commit()

      return

  hasDeal: Ember.computed 'deal', ->
    @get('deal')
