Radium.UserFeedSection = Radium.FeedSection.extend Radium.NestedFeedSection,
  associatedArrayName: 'associatedUsers'
  recordType: Radium.User
  type: 'user'
  record: DS.belongsTo('Radium.User', key: 'record_id')
