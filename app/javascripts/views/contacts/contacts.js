Radium.ContactsPageView = Ember.View.extend({
  templateName: 'contacts',

  selectedCampaignBinding: 'Radium.selectedContactsController.selectedCampaign',
  selectedFilterBinding: 'Radium.selectedContactsController.selectedFilter',

  noSelectedCampaigns: function() {
    return (this.get('selectedCampaign')) ? false : true;
  }.property('selectedCampaign').cacheable(),

  noSelectedFilter: function() {
    return (this.get('selectedFilter')) ? false : true;
  }.property('selectedFilter').cacheable(),

  campaignsFilterView: Ember.View.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked',

    allCampaigns: function(event) {
      Radium.App.send('allCampaigns');
      return false;
    }
  }),

  contactsFilterView: Ember.View.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked',

    allContacts: function(event) {
      this.setPath('parentView.selectedFilter', null);
      return false;
    }
  })
});

Radium.CampaignListView = Ember.View.extend({
  tagName: 'li',
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    var campaign = this.get('item'),
        selectedCampaign = this.getPath('parentView.parentView.selectedCampaign');
    if (campaign === selectedCampaign) { return true; }
  }.property('parentView.parentView.selectedCampaign').cacheable(),
  filterCampaigns: function(event) {
    var campaign = this.get('item');
    Radium.App.send('selectCampaign', campaign);
    return false;
  }
});

Radium.ContactFilterListView = Ember.View.extend({
  tagName: 'li',
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    var filter = this.get('singularName'),
        selectedFilter = this.getPath('parentView.parentView.selectedFilter');
    if (filter === selectedFilter) { return true; }
  }.property('parentView.parentView.selectedFilter').cacheable(),
  filterContacts: function(event) {
    var filter = this.get('singularName');
    Radium.contactsController.clearSelected();
    Radium.selectedContactsController.set('selectedFilter', filter);
    return false;
  },

  newResourceButton: Ember.View.extend({
    classNames: 'icon-plus',
    tagName: 'i',
    attributeBindings: ['title'],
    click: function(event) {
      var formType = this.get('formViewClass');
      Radium.App.send('addResource', formType);
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