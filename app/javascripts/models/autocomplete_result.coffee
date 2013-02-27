Radium.AutoCompleteResult = Radium.Model.extend
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  hasResults: ( ->
    @get('users.length') || @get('contacts.length')
  ).property('users', 'contacts', 'users.length', 'contacts.length')
