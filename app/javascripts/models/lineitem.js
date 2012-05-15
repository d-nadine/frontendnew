Radium.LineItem = DS.Model.extend({
  name: DS.attr('string'),
  quantity: DS.attr('number'),
  price: DS.attr('number'),
  currency: DS.attr('string'),
  product: DS.belongsTo('Radium.Product'),
  deal: DS.belongsTo('Radium.Deal')
});