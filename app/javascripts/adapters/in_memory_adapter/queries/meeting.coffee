Radium.InMemoryAdapter.reopen
  queryMeetingRecords: (records, query) ->
    if query.user && query.day
      return records.filter (meeting) ->
        return false unless meeting.startsAt && meeting.users
        meeting.users.contains(query.user) && meeting.startsAt.toDateFormat() == query.day.toDateFormat()

    records

