Radium.LoadingView = Ember.View.extend({
  elementId: 'loading',
  classNames: 'progress progress-info progress-striped active'.w(),
  template: Ember.Handlebars.compile('<div class="bar" style="width: 40%;"></div>')
});