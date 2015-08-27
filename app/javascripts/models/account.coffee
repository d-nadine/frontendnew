Radium.Account = Radium.Model.extend
  name: DS.attr('string')
  users: DS.hasMany('Radium.User')
  leadSources: DS.attr('array')
  gatewaySetup: DS.attr('boolean')
  subscriptionInvalid: DS.attr('boolean')
  isTrial: DS.attr('boolean')
  trialDaysLeft: DS.attr('number')
  unlimited: DS.attr('boolean')
  importedContactsGlobal: DS.attr('boolean')
  currency: DS.attr('string')

  billing: DS.belongsTo('Radium.Billing')
