import Ember from 'ember';
import MentionField from 'radium/components/mention-field';

export default MentionField.extend({
  classNameBindings: ['value:is-valid', 'isInvalid', ':todo'],
  valueBinding: 'parentView.description',
  dateBinding: 'parentView.finishBy',
  isSubmitted: Ember.computed.oneWay('parentView.isSubmitted'),
  isInvalid: Ember.computed('value', 'isSubmitted', function() {
    return Ember.isEmpty(this.get('value')) && this.get('isSubmitted');
  }),
  referenceName: Ember.computed.oneWay('parentView.reference.name'),
  setup: Ember.on('didInsertElement', function() {
    this.set('register-as', this);
  })
});

