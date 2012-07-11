Radium.DealLineItemView = Radium.Fieldset.extend({
  classNames: ['control-group'],
  templateName: 'deal_line_item',
  nameField: Ember.TextField.extend({
    placeholder: 'Name',
    classNames: ['input-small']
  }),
  quantityField: Ember.TextField.extend({
    placeholder: 'Quantity',
    classNames: ['input-small']
  }),
  priceField: Ember.TextField.extend({
    placeholder: 'Price',
    classNames: ['input-small']
  }),
  currencySelect: Ember.Select.extend({
    content: Ember.A([
      "USD",
      "CAD",
      "EUR",
      "British Pound"
    ])
  })
});