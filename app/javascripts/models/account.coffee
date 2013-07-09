Radium.Account = Radium.Model.extend
  workflow: DS.hasMany('Radium.Workflow')
  users: DS.hasMany('Radium.User')
  leadSources: DS.attr('array')
