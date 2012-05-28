Radium.FeedDateGroupView = Ember.View.extend({
  layoutName: 'date_group',
  defaultTemplate: 'today',
  template: Ember.computed(function() {
    var templateName = this.getPath('content.dateKind'),
        template = this.templateForName(templateName, 'template');
        console.log(templateName);
    return template || this.get('defaultTemplate');
  }).property('content.dateKind').cacheable()
});