Radium.CreateTrialPlan = Radium.Model.extend
  user: DS.belongsTo('Radium.User')
  account: DS.belongsTo('Radium.Account')
  subscriptionPlan: DS.belongsTo('Radium.SubscriptionPlan')

Radium.UpdateTrialPlan = Radium.CreateTrialPlan.extend()
