Radium.FeedFilterItemView = Ember.View.extend({
  tagName: 'li',
  templateName: 'filter',
  classNames: ['main-filter-item'],
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    return (Radium.getPath('appController.filter') == this.getPath('content.kind')) ? true : false;
  }.property('Radium.appController.filter').cacheable(),
  setFilter: function(event) {
    var kind = this.getPath('content.kind');
    Radium.setPath('appController.filter', kind);
    
    Radium.get('appController').toggleKind();

    return false;
  },
  addResourceButton: Ember.View.extend({
    classNames: 'icon-plus'.w(),
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
      var $sender = $(event.target),
          kind = this.getPath('parentView.content.label'),
          formType = (this.singular[kind]) 
                    ? this.singular[kind] 
                    : kind.replace(' ', '').slice(0, -1);

      Radium.FormContainerView['show' + formType + 'Form']();
      return false;
    }
  }),
  iconView: Radium.SmallIconView,

  badge: Ember.View.extend({
    tagName: 'span',
    classNames: ['pull-right'],
    template: Ember.Handlebars.compile('<span class="badge">{{count}}</span>')
  })
});
