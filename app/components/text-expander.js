import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

export default Component.extend({
  actions: {
    expand() {
      this.set('current', this.get('current') + this.step);
    }
  },

  current: 0,
  step: 5,
  hasMore: false,

  truncatedText: computed('text', 'current', function(){
    const text = this.get('text') || '';

    if(!text.length) {
      return false;
    }

    const parts = text.split("<br/>"),
          next = this.current + this.step;

    if(next >= parts.length || this.current > 0) {
      this.set('hasMore', false);

      return parts.join('<br/>');
    }

    this.set('hasMore', true);

    return parts.slice(0, next).join('<br/>');
  })
});