import Model from 'radium/models/models';

const Technology = Model.extend({
  name: DS.attr('string')
});

export default Technology;

Technology.toString = function() {
  return "Radium.Technology";
};
