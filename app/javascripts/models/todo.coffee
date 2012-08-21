Radium.Todo = Radium.Core.extend Radium.CommentsMixin,
  isEditable: true
  hasAnimation: false
  kind: DS.attr("todoKind")
  description: DS.attr("string")
  finishBy: DS.attr("datetime",
    key: "finish_by"
  )
  finished: DS.attr("boolean")
  campaign: DS.belongsTo("Radium.Campaign")
  callList: DS.belongsTo("Radium.CallList",
    key: "call_list"
  )
  isCall: ( ->
    (if (@get("kind") is "call") then true else false)
  ).property("kind")
  contact: DS.belongsTo("Radium.Contact",
    embedded: true
  )
  contacts: DS.hasMany("Radium.Contact")
  notes: DS.hasMany("Radium.Note",
    embedded: true
  )
  overdue: DS.attr("boolean")
  reference: DS.attr("object")
  user: DS.belongsTo("Radium.User",
    key: "user"
  )
  user_id: DS.attr("number")
  # Turn on when todo's are created from the form
  hasNotificationAnim: DS.attr("boolean")
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get("finishBy")
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property("finishBy")
  canComplete: ( ->
    (if (@get("user.apiKey")) then true else false)
  ).property("user")
  canEdit: ( ->
    (if (@get("user.apiKey") and not @get("finished")) then true else false)
  ).property("user", "finished")
