Radium.PeopleContactsRoute = Radium.Route.extend
  beforeModel: (transition) ->
    self = this

    unless @controllerFor('currentUser').get('initialContactsImported')
      return @transitionTo "people.index", "potential", queryParams: hidesidebar: false

    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.ContactsTotals.find({public_and_potential_only: true})
      .then((totals) ->
        totals = totals.get('firstObject')
        all = totals.get('all')
        potential = totals.get('potential')

        if all == 0
          self.transitionTo "people.index", "potential", queryParams: hidesidebar: false
        else
          self.transitionTo "people.index", "all", queryParams: hidesidebar: false
        resolve()
      ).catch (error) ->
        self.transitionTo "people.index", "all", queryParams: hidesidebar: false
        reject(error)
