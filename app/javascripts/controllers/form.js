/**
  A proxy for any data needed to be prepopulated in a form.
  @
*/
Radium.FormProxy = Ember.Object.extend({
  // Any data we can pass along for the form field
  data: null,
  // The form class name, eg `Message`, `Todo` or `contactSMS`
  form: null
});