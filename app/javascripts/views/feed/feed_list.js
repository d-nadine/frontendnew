Radium.FeedListView = Ember.View.extend({
  tagName: 'td',
  // phrases: {
  //   '{{owner.user.name}} {{tag}} a {{kind}}'
  // },
  template: function() {
    var template = this.get('strings')
    return Ember.Handlebars.compile()
  }
});