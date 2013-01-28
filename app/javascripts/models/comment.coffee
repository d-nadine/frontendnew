Radium.Comment = Radium.Core.extend
  text: DS.attr('string')

  commentable: DS.attr('object')
  user: DS.belongsTo('Radium.User', inverse: 'comments')
