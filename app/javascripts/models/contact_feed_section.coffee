Radium.ContactFeedSection = Radium.FeedSection.extend Radium.NestedFeedSection,
  associatedArrayName: 'associatedContacts'
  recordType: Radium.Contact
  type: 'contact'
  record: DS.belongsTo('Radium.Contact', key: 'record_id')
