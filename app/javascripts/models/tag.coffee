Radium.Tag = Radium.Model.extend
  name: DS.attr('string')
  description: DS.attr('string')
  user: DS.belongsTo('Radium.User')
