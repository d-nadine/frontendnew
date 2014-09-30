Radium.Account = Radium.Model.extend
  name: DS.attr('string')
  workflow: DS.hasMany('Radium.Workflow')
  users: DS.hasMany('Radium.User')
  leadSources: DS.attr('array')
  gatewaySetup: DS.attr('boolean')
  subscriptionInvalid: DS.attr('boolean')
  isTrial: DS.attr('boolean')
  trialDaysLeft: DS.attr('number')
  unlimited: DS.attr('boolean')
  importedContactsGlobal: DS.attr('boolean')

  billing: DS.belongsTo('Radium.Billing')
