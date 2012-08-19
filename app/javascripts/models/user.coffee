###
@extends {Class} Person
###
Radium.User = Radium.Person.extend
  apiKey: DS.attr("string",
    key: "api_key"
  )
  displayName: (->
    (if (@get("apiKey")) then "Me" else @get("abbrName"))
  ).property("name")
  avatar: DS.attr("object")
  email: DS.attr("string")
  phone: DS.attr("string")
  account: DS.attr("number")
  contacts: DS.hasMany("Radium.Contact")
  following: DS.hasMany("Radium.User")
  feed: null
  campaign: DS.belongsTo("Radium.Campaign")
  notes: DS.hasMany("Radium.Note",
    embedded: true
  )
  url: (->
    "/users/%@".fmt @get("id")
  ).property("id")
  leads: (->
    contacts = @get("contacts")
    contacts.filterProperty "status", "lead"
  ).property("contacts").cacheable()
  prospects: (->
    contacts = @get("contacts")
    contacts.filterProperty "status", "prospect"
  ).property("contacts").cacheable()
  pendingDeals: (->
    deals = @get("deals")
    deals.filterProperty "state", "pending"
  ).property("deals").cacheable()
  closedDeals: (->
    deals = @get("deals")
    deals.filterProperty "state", "closed"
  ).property("deals").cacheable()
  paidDeals: (->
    deals = @get("deals")
    deals.filterProperty "state", "paid"
  ).property("deals").cacheable()
  rejectedDeals: (->
    deals = @get("deals")
    deals.filterProperty "state", "rejected"
  ).property("deals").cacheable()
  isLoggedIn: (->
    (if (@get("apiKey")) then true else false)
  ).property("apiKey").cacheable()
