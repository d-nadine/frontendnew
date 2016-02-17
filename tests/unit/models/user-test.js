import { moduleForModel, test } from 'ember-qunit';

moduleForModel('user', 'Unit | Model | user');

test('name correctly concats firstName and lastName', function(assert) {
  let user = this.subject({firstName: 'Walter', lastName: 'White'});

  assert.equal(user.get('name'), 'Walter White');
});
