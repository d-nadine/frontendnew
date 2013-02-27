Radium.AutoCompleteResult = Radium.Model.extend
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  hasResults: ( ->
    @get('users.length') || @get('contacts.length')
  ).property('users', 'contacts', 'users.length', 'contacts.length')

Radium.AutoCompleteResult.reopenClass
  comparer: (a, b) ->
    sortA = a.get('name') || a.get('email')
    sortB = a.get('name') || a.get('email')

    if sortA > sortB
     return 1
    else if sortA < sortB
     return - 1

    0
