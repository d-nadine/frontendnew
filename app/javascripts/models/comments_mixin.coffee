Radium.CommentsMixin = Em.Mixin.create
  comments: DS.hasMany('Radium.Comment',
    # TODO: embedded comments didn't work, to investigate
    key: 'comment_ids'
  )
