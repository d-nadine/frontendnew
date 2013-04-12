class AddressBook
  lookup: (email, callback) ->
    user = Radium.User.all().find (user) -> user.get('email') is email
    return user if user

    contact = Radium.Contact.all().find (contact) -> contact.get('email') is email
    return contact if contact

    contact = Radium.Contact.createRecord
      email: email

    callback contact
    contact

Radium.FixtureAdapter.reopen
  willCreateEmail: (email, transaction) ->
    return unless email.get('addresses')

    addressBook = new AddressBook

    email.set 'to', email.get('addresses.to').map (address) ->
      addressBook.lookup address, (contact) ->
        contact.set 'user', email.get('sender')
        transaction.add contact
