Radium.AddDealComponent = Ember.Component.extend
  actions:
    addDeal: ->
      @set('isSubmitted', true)
      parent = if @get('parent') instanceof Ember.ObjectController
                 @get('parent.model')
               else
                 @get('parent')

      return unless deal = parent.get('deal')

      unless @get('isNew')
        parent.reloadAfterUpdateEvent('didUpdate')

        @get('store').commit()

      @send 'closeForm'
      false

    closeForm: ->
      @get('targetObject').send 'toggleAddDealForm'
      false

  isNew: Ember.computed 'targetObject.id', ->
    not !!@get('targetObject.id')

  isSubmitted: false

  dealsExist: Ember.computed ->
    Radium.Deal.all().get('length')

  classNameBindings: [':email-item-actions', ':new-message-row', ':add-deal']
