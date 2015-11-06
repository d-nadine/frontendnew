import Ember from 'ember';
import resolver from './helpers/resolver';
import {
  setResolver
} from 'ember-qunit';

const {
  run
} = Ember;

function focus(el) {
  if (el && el.is(':input, [contenteditable=true]')) {
    var type = el.prop('type');
    if (type !== 'checkbox' && type !== 'radio' && type !== 'hidden') {
      run(el, function() {
        // Firefox does not trigger the `focusin` event if the window
        // does not have focus. If the document doesn't have focus just
        // use trigger('focusin') instead.
        if (!document.hasFocus || document.hasFocus()) {
          this.focus();
        } else {
          this.trigger('focusin');
        }
      });
    }
  }
}

function fillInContentEditable(app, selector, contextOrText, text) {
  var $el, context;
  if (typeof text === 'undefined') {
    text = contextOrText;
  } else {
    context = contextOrText;
  }
  $el = app.testHelpers.findWithAssert(selector, context);
  focus($el);
  run(function() {
    $el.text(text);

    run($el, "trigger", "input");

    run.next(() => {
      const e = $.Event('keydown');

      e.keyCode = e.which = 13;

      $el.trigger(e);
    });
  });

  return app.testHelpers.wait();
}

Ember.Test.registerAsyncHelper('fillInContentEditable', fillInContentEditable);

setResolver(resolver);
