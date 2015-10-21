import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  createdAt: DS.attr("datetime"),
  upeatedAt: DS.attr("datetime")
});
