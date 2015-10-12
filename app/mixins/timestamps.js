import Ember from 'ember';

export default Ember.Mixin.create({
  createdAt: DS.attr("datetime"),
  upeatedAt: DS.attr("datetime")
});
