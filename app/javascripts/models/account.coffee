Radium.Account = Radium.Model.extend
  name: DS.attr('string')
  workflow: DS.hasMany('Radium.Workflow')
  users: DS.hasMany('Radium.User')
  leadSources: DS.attr('array')
  billingInfo: DS.belongsTo('Radium.BillingInfo')
  gatewaySetup: DS.attr('boolean')
