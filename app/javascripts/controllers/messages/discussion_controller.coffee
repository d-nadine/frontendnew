Radium.MessagesDiscussionController = Ember.ObjectController.extend
  aboutDeal: (->
    @get('reference') instanceof Radium.Deal
  ).property('reference')

  aboutContact: (->
    @get('reference') instanceof Radium.Contact
  ).property('reference')

  activeDeal: (->
    if @get('aboutDeal')
      @get('reference')
    else
      null
  ).property('reference')
