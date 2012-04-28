Radium.FeedFilterItemView = Ember.View.extend({
  tagName: 'li',
  templateName: 'type_filters',
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    return (this.getPath('parentView.filter') == this.getPath('content.kind')) ? true : false;
  }.property('parentView.filter').cacheable(),
  
  // Actions
  setFilter: function(event) {
    var kind = this.getPath('content.kind');
    this.setPath('parentView.filter', kind);
    return false;
  },
  addResourceButton: Ember.View.extend({
    classNames: 'icon-plus',
    tagName: 'i',
    attributeBindings: ['title'],
    singular: {
      'Companies': 'Company'
    },
    title: function() {
      var type = this.getPath('parentView.content.label');
      return "Add a new " + type.substr(0, type.length-1);
    }.property(),
    click: function(event) {
      var kind = this.getPath('parentView.content.label'),
          formType = (this.singular[kind]) 
                    ? this.singular[kind] 
                    : kind.replace(' ', '').slice(0, -1);
      Radium.FormManager.send('showForm', {form: formType});
      event.stopPropagation();
      return false;
    }
  }),
  badge: Ember.View.extend({
    tagName: 'span',
    classNames: ['pull-right'],
    template: Ember.Handlebars.compile('<span class="badge">{{count}}</span>')
  })
});