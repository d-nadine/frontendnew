import Model from 'radium/models/models';
import Ember from 'ember';

const {
  computed
} = Ember;

const ListStatus = Model.extend({
  name: DS.attr('string'),
  position: DS.attr('number'),
  statusType: DS.attr('string'),
  list: DS.belongsTo('Radium.List', {inverse: 'listStatuses'}),

  isActive: computed.equal('statusType', 'active')
});

ListStatus.toString = function() {
  return "Radium.ListStatus";
};

export default ListStatus;
