Radium.InMemoryAdapter.reopen
  queryMeetingRecords: (records, query) ->
    if query.user && query.day
      return records.filter (meeting) ->
        return false unless meeting.startsAt && meeting.users
        return false unless meeting.id
        meeting.users.contains(query.user) &&
          meeting.startsAt.toDateFormat() == query.day.toDateFormat() &&
          meeting.id + "" != query.meetingId

    records

