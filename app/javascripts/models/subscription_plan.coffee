Radium.SubscriptionPlan = Radium.Model.extend
  planId: DS.attr('string')
  name: DS.attr('string')
  amount: DS.attr('number')
  interval: DS.attr('string')
  currency: DS.attr('string')
  totalUsers: DS.attr('number')
  disabled: DS.attr('boolean')
  displayOrder: DS.attr('number')
