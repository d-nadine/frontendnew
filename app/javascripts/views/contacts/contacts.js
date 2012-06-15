Radium.ContactsPageView = Ember.View.extend({
  controller: Radium.contactsController,
  templateName: 'contacts',

  selectedCampaignBinding: 'Radium.selectedContactsController.selectedCampaign',
  selectedFilterBinding: 'Radium.selectedContactsController.selectedFilter',

  noSelectedCampaigns: function() {
    return (this.get('selectedCampaign')) ? false : true;
  }.property('selectedCampaign').cacheable(),

  noSelectedFilter: function() {
    return (this.get('selectedFilter')) ? false : true;
  }.property('selectedFilter').cacheable(),
 
  // Infinite scrolling (To be reincorporated into own mixin)
  didInsertElement: function() {
    this._super();
  },

  willDestroyElement: function() {
    $(window).off('scroll');
  },

  infiniteLoading: function() {
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 300) {
      Radium.App.goToState('loading');
      $(window).off('scroll');
      this.load();
      return false;
    }
  },

  pagesLoaded: function() {
    if (this.getPath('controller.currentPage') < this.getPath('controller.totalPages')) {
      Radium.App.goToState('ready');
      $(window).on('scroll', $.proxy(this.infiniteLoading, this));
    } else {
      $(window).off('scroll');
    }
  }.observes('controller.currentPage'),

  load: function() {
    this.get('controller').load();
  }
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
