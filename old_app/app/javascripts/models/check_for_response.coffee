Radium.CheckForResponse = Radium.Model.extend Radium.HasTasksMixin,
  subject: DS.attr('string')
  time: DS.attr('datetime')
  createdBy: DS.belongsTo('Radium.User')
  user: DS.belongsTo('Radium.User')
  contact: DS.belongsTo('Radium.Contact')
  responder: Ember.computed 'user', 'contact', ->
    @get('contact', 'user')