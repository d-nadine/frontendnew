Radium.Comment = Radium.Core.extend
  dateToISO8601: (->
    return this.get('createdAt').toISO8601()
  ).property('createdAt')
  text: DS.attr('string')
  user: DS.belongsTo 'Radium.User',
    key: 'user_id'
  attachments: DS.hasMany('Radium.Attachment')
  commentableId: DS.attr('number', key: 'commentable_id')
  commentableType: DS.attr('string', key: 'commentable_type')
