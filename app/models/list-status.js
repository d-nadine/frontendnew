import Ember from 'ember';

const {
  computed
} = Ember;

import Model from 'radium/models/models';

const ListStatus = Model.extend({
  name: DS.attr('string'),
  position: DS.attr('number'),
  statusType: DS.attr('string'),
  list: DS.belongsTo('Radium.List', {inverse: 'listStatuses'}),

  isActive: computed.equal('statusType', 'active')
});

export default ListStatus;

ListStatus.toString = function() {
  return "Radium.ListStatus";
};
