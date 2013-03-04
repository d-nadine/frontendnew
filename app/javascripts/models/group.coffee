Radium.Group = Radium.Model.extend Radium.FollowableMixin,
  name: DS.attr('string')
  address: DS.belongsTo('Radium.Address')
