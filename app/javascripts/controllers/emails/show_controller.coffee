Radium.EmailsShowController = Radium.ObjectController.extend Radium.ChangeContactStatusMixin,
  activeDeal: Ember.computed.alias('contact.deals.firstObject')
  nextTask: Ember.computed.alias('contact.nextTask')

  contact: ( ->
    sender = @get('sender')

    return sender if sender instanceof Radium.Contact
  ).property('sender')

  showHud: (-> 
    !Ember.isNone(@get('contact'))
  ).property('contact')

  history: (->
    Radium.Email.filter (otherEmail) => 
      @get('model').isIncludedInConversation otherEmail
  ).property('model')
