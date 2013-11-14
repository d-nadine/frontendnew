Radium.ExternalContact = Radium.Model.extend
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  addresses: DS.hasMany('Radium.Address')

  user: DS.belongsTo('Radium.User')

  contactInfo: DS.belongsTo('Radium.ContactInfo')

  name: DS.attr('string')
  title: DS.attr('string')
  avatarKey: DS.attr('string')
  notes: DS.attr('string')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  email: Ember.computed.alias 'primaryEmail.value'

  displayName: ( ->
    @get('name') || @get('primaryEmail.value') || @get('primaryPhone.value')
  ).property('name', 'primaryEmail', 'primaryPhone')
