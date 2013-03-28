Radium.FixtureAdapter.reopen
  queryMeetingFixtures: (records, query) ->
    if query.user && query.day
      return records.filter (meeting) ->
        return false unless meeting.startsAt && meeting.users
        meeting.users.contains(query.user) &&
          meeting.startsAt.toDateFormat() == query.day.toDateFormat() &&
          meeting.id + "" != query.exclude

    records

