// import Ember from 'ember';
// import Model from 'radium/models/models';

// const List = Model.extend({
//   name: DS.attr('string'),
//   itemName: DS.attr('string'),
//   type: DS.attr('string'),
//   listStatuses: DS.hasMany('Radium.ListStatus', {
//     inverse: 'list'
//   }),
//   contactList: Ember.computed.equal('type', 'contacts'),
//   companiesList: Ember.computed.equal('type', 'companies'),
//   actionListStatus: DS.belongsTo('Radium.ListStatus', {
//     inverse: null
//   }),
//   listAction: DS.attr('string'),
//   actionList: DS.belongsTo('Radium.List', {
//     inverse: null
//   }),
//   initialStatus: DS.belongsTo('Radium.ListStatus', {
//     inverse: null
//   }),
//   clearRelationships: function() {
//     return this.get('listStatuses').compact().forEach(function(status) {
//       return status.unloadRecord();
//     });
//   }
// });

// export default List;

// List.toString = () => "Radium.List";
