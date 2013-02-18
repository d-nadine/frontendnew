Radium.Discussion = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  topic: DS.attr('string')
  user: DS.belongsTo('Radium.User')
