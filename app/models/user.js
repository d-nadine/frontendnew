import DS from 'ember-data';

export default DS.Model.extend({
  account: DS.belongsTo('account', {
    async: false
  }),
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  title: DS.attr('string'),
  isAdmin: DS.attr('boolean'),
  email: DS.attr('string'),
  avatarKey: DS.attr('string')
});
