Radium.LineItem = DS.Model.extend({
  name: DS.attr('string'),
  quantity: DS.attr('integer'),
  price: DS.attr('integer'),
  currency: DS.attr('string'),
  product: DS.hasOne('Radium.Product'),
  deal: DS.hasOne('Radium.Deal')
});