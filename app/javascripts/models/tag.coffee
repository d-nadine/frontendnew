Radium.Tag = Radium.Model.extend Radium.FollowableMixin,
  activities: DS.hasMany('Radium.Activity')
  name: DS.attr('string')
  address: DS.belongsTo('Radium.Address')
