Radium.PeopleContactsRoute = Radium.Route.extend
  beforeModel: (transition) ->
    self = this
    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.ContactsTotals.find({public_and_potential_only: true})
      .then((totals) ->
        totals = totals.get('firstObject')
        all = totals.get('all')
        potential = totals.get('potential')

        if all == 0 && potential > 0
          self.transitionTo "people.index", "potential"
        else
          self.transitionTo "people.index", "all"
        resolve()
      ).catch (error) ->
        self.transitionTo "people.index", "all"
        reject(error)
