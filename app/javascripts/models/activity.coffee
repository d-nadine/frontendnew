Radium.Activity = Radium.Model.extend Radium.CommentsMixin,
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  companies: DS.hasMany('Radium.Company')
  # FIXME: remove when ED supports has many through
  tags: DS.hasMany('Radium.Tag')

  tag: DS.attr('string')
  event: DS.attr('string')
  meta: DS.attr('object')
