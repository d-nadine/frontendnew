Radium.Discussion = Radium.Model.extend Radium.CommentsMixin, Radium.AttachmentsMixin,
  topic: DS.attr('string')
  # FIXME: Is sentAt relevant for discussions
  sentAt: DS.attr('datetime')
  user: DS.belongsTo('Radium.User')
