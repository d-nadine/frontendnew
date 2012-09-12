Radium.GroupFeedSection = Radium.FeedSection.extend Radium.NestedFeedSection,
  associatedArrayName: 'associatedGroups'
  recordType: Radium.Group
  type: 'group'
  record: DS.belongsTo('Radium.Group', key: 'record_id')
