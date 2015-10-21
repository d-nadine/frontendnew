import Model from 'radium/models/models';
import Ember from 'ember';

const ConversationsTotals = Model.extend({
  incoming: DS.attr('number'),
  replied: DS.attr('number'),
  waiting: DS.attr('number'),
  later: DS.attr('number'),
  allUsersTotals: DS.attr('number'),
  usersTotals: DS.attr('array'),
  sharedTotals: DS.attr('array')
});

export default ConversationsTotals;

ConversationsTotals.toString = function() {
  return "Radium.ConversationsTotals";
};