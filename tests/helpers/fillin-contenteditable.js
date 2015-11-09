import Ember from 'ember';
import focus from './focus';

const {
  run
} = Ember;

function fillInContentEditable(app, selector, contextOrText, text) {
  var $el, context;
  if (typeof text === 'undefined') {
    text = contextOrText;
  } else {
    context = contextOrText;
  }
  $el = app.testHelpers.findWithAssert(selector, context);
  focus.focus($el);
  run(function() {
    $el.text(text);

    run($el, "trigger", "input");

    run.next(() => {
      ['keydown'].forEach((keyEvt) => {
        const e = $.Event(keyEvt);

        e.keyCode = e.which = 13;

        $el.trigger(e);
      });
    });
  });

  return app.testHelpers.wait();
}

Ember.Test.registerAsyncHelper('fillInContentEditable', fillInContentEditable);
