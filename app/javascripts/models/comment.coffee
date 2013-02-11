Radium.Comment = Radium.Model.extend Radium.AttachmentsMixin,
  text: DS.attr('string')
  commentable: DS.attr('object')

  user: DS.belongsTo('Radium.User')
