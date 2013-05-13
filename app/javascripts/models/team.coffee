Radium.Team = Radium.Model.extend
  name: DS.attr('string')
  users: DS.hasMany('Radium.User', inverse: 'team')
