Radium.ActivityView = Ember.View.extend({
  templateName: function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_');

    return templateName;
  }.property()
});
