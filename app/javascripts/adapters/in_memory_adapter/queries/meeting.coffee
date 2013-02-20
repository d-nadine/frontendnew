Radium.InMemoryAdapter.reopen
  queryMeetingRecords: (records, query) ->
    if query.user && query.day
      return records.filter (meeting) ->
        return false unless meeting.startsAt
        meeting.user == query.user.get('id') && meeting.startsAt.toDateFormat() == query.day.toDateFormat()

    records

