###
@extends {Class} Person
###
Radium.User = Radium.Person.extend
  displayName: (->
    (if (@get('apiKey')) then 'Me' else @get('abbrName'))
  ).property('name')
  email: DS.attr('string')
  phone: DS.attr('string')
  contacts: DS.hasMany('Radium.Contact')
