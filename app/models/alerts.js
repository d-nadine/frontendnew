import Model from 'radium/models/models';

const Alerts = Model.extend({
  extensionSeend: DS.attr('boolean')
});

export default Alerts;

Alerts.toString = function() {
  return "Radium.Alerts";
};