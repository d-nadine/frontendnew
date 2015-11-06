import Model from 'radium/models/models';

const MarketCategory = Model.extend({
  name: DS.attr('string')
});

export default MarketCategory;

MarketCategory.toString = function() {
  return "Radium.MarketCategory";
};
