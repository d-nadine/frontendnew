import Ember from 'ember';
import focus from './focus';

const {
  run
} = Ember;


function fillInWithInputEvent(app, selector, contextOrText, textOrEvents, event) {
  var $el, context, text;

  if (typeof event === 'undefined') {
    context = null;
    text = contextOrText;
    event = textOrEvents;
  } else {
    context = contextOrText;
    text = textOrEvents;
  }

  $el = app.testHelpers.findWithAssert(selector, context);

  focus.focus($el);

  function fillInWithEvent() {
    const character = text.slice(-1);
    const charCode = character.charCodeAt(0);

    run(function() {
      $el.text(text);
    });

    [event, 'input'].forEach((evt) => {
      run.next($el, "trigger", evt, { keyCode: charCode, which: charCode });
    });
  }

  fillInWithEvent();

  return app.testHelpers.wait();
}

Ember.Test.registerAsyncHelper('fillInWithInputEvent', fillInWithInputEvent);
