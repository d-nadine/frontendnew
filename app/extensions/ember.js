import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

Component.reopen({
  classNameBindings: ['viewClassName'],

  viewClassName: computed(function() {
    const constructor = this.constructor.toString();

    if(!constructor.match(/radium/)) {
      return undefined;
    }

    if(!constructor.match(/@view/) && !constructor.match(/@component/)) {
      return undefined;
    }

    const result = constructor.split(':')[1].dasherize();

    if(result[0] !== '-') {
      return `${result}-component`;
    } else {
      return undefined;
    }
  })
});