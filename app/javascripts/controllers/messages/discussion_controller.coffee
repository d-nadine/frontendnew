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
      @get('latestDeal')
  ).property('reference')

  nextTask: (->
    @get('reference.nextTask')
  ).property('reference.nextTask')

  contact: (->
    if @get('aboutDeal')
      @get('reference.contact')
    else
      @get('reference')
  ).property('reference')

