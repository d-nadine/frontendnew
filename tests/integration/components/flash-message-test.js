import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('flash-message', 'Integration | Component | flash message', {
  integration: true
});

test('renders a success message', function(assert) {
  assert.expect(4);

  this.set('flashMessage', {
    type: 'alert-success',
    message: 'we did it!'
  });

  this.render(hbs`{{flash-message messagePart=flashMessage}}`);

  assert.equal(this.$().text().trim(), 'we did it!');

  const el = this.$('.alert');

  assert.ok(el, 'there is an alert element');

  assert.ok(el.is(':visible'), 'alert is visible');
  assert.ok(el.hasClass('alert-success'), 'success class is set');
});
