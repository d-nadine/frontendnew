Radium.FixtureAdapter.reopen
  # This method must simulate logic done by the server.
  # It has two primary functions:
  #
  # 1. Load the feed for a given resource (user,contact,group)
  # 2. Query the feed for laoding purposes (infinite scroller)
  #
  # Queries options
  #
  # * scope: the resource to load the feed for **REQUIRED**
  # * nearDate: load the feed date closest to the given date
  # * before: load the feed before this date
  # * after: load the feed after this date
  # * date: load the feed for a specific date
  # * limit: the number of items to load
  queryFeedSectionFixtures: (fixtures, query) ->
    throw new Error("Scope require to query the feed!") unless query.scope

    scoped = fixtures.filter (f) ->
      true # FIXME: figure out why the feed association is not there

    if query.nearDate
      # First filter out everything newer than the given date
      cutOff = query.nearDate.get 'milliseconds'

      scoped = scoped.filter (f) ->
        Ember.compare(cutOff, Date.parse(f.date)) == 1

      # Sort the rest in descending order
      scoped = scoped.sort (f1, f2) ->
        date1 = Date.parse f1.date
        date2 = Date.parse f2.date
        Ember.compare date2, date1

      # take an arbitrary slice of it
      scoped = scoped.slice 0, 5

    else if query.date
      formattedDate = query.date.toDateFormat()

      scoped = scoped.filter (f) ->
        f.id == formattedDate

    else if query.before
      cutOff = query.before.get 'milliseconds'

      scoped = scoped.filter (f) ->
        Ember.compare(cutOff, Date.parse(f.date)) != 0

    else if query.after
      cutOff = query.after.get 'milliseconds'

      scoped = scoped.filter (f) ->
        Ember.compare(cutOff, Date.parse(f.date)) == -1

    if query.limit
      scoped.slice 0, query.limit
    else
      scoped
