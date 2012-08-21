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
  campaign: DS.belongsTo("Radium.Campaign")
  notes: DS.hasMany("Radium.Note",
    embedded: true
  )
