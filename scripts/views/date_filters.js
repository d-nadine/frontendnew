define('views/date_filter', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/date_filters.handlebars');

  Radium.DateFilterView = Ember.View.extend({
    classNames: 'span12'.w(),
    template: Ember.Handlebars.compile(template),
    testView: Ember.CollectionView.extend({
      tagName: 'ul',
      content: [
        Ember.Object.create({label: "Daily", type: "day"}),
        Ember.Object.create({label: "Weekly", type: "week"}),
        Ember.Object.create({label: "Monthly", type: "month"}),
        Ember.Object.create({label: "Quarterly", type: "quarter"}),
        Ember.Object.create({label: "Yearly", type: "year"})
      ],
      itemViewClass: Ember.View.extend({
        dateFilterBinding: 'Radium.activityDateGroupsController.dateFilter',
        isSelected: function() {
          return (this.get('dateFilter') === this.getPath('content.type')) ?
                  true : false;
        }.property('dateFilter').cacheable(),
        classNameBindings: ['isSelected:active'],
        click: function() {
          var filterType = this.getPath('content.type');
          Radium.activityDateGroupsController.set('dateFilter', filterType);
          return false;
        },
        template: Ember.Handlebars.compile('<a href="#">{{content.label}}</a>')
      }),
    })
  });

  return Radium;
});