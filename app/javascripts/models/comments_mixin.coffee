Radium.CommentsMixin = Em.Mixin.create
  comments: DS.hasMany "Radium.Comment",
    embedded: true
    key: "comments"
