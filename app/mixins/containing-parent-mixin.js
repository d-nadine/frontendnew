import Ember from 'ember';

const {
  Mixin,
  computed
} = Ember;

export default Mixin.create({
  containingParent: computed(function() {
    let parent;

    if((parent = this.get('parent'))) {
      return parent;
    } else {
      return this.get('targetObject.table.targetObject');
    }
  })
});
