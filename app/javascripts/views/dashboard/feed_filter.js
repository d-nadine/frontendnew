Radium.DashboardFeedFilterView = Radium.FeedFilterView.extend({
  filterBinding: 'Radium.feedByKindController.filter',
  groupBinding: 'Radium.feedByKindController.group',
  content: [
    {label: "Everything", kind: null, addButton: false},
    {label: "Todos", kind: 'todo', addButton: true},
    {label: "Deals", kind: 'deal', addButton: true},
    {label: "Campaigns", kind: 'campaign', addButton: true},
    {label: "Phone Calls", kind: 'phone_call', addButton: false},
    {label: "Call Lists", kind: 'call_list', addButton: true},
    {label: "Meetings", kind: 'meeting', addButton: true},
    {label: "Contacts", kind: 'contact', addButton: true}
  ],
  // Add the notification list item after, since it isn't a loopable addButton
  didInsertElement: function() {
    var notificationView = Ember.View.create({
      tagName: 'li',
      notificationsBinding: 'Radium.dashboardFeedController.size',
      click: function() {return false;},
      template: Ember.Handlebars.compile('<a href="#">Notifications <span class="badge badge-error">{{notifications}}</span></a>')
    });
    this.get('childViews').pushObject(notificationView);
  },
  itemViewClass: Ember.View.extend({
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
      title: function() {
        var type = this.getPath('parentView.content.label');
        return "Add a new " + type.substr(0, type.length-1);
      }.property(),
      click: function(event) {
        var kind = this.getPath('parentView.content.label'),
            formType = kind.replace(' ', '').slice(0, -1);
        Radium.App.send('addResource', {form: formType});
        event.stopPropagation();
        return false;
      }
    })
  })
});