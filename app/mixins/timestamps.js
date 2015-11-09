import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  createdAt: DS.attr("datetime"),
  updatedAt: DS.attr("datetime")
});
