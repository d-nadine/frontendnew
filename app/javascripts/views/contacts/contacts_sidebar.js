Radium.ContactsSideBar = Ember.View.extend({
  templateName: 'contacts_sidebar',
  campaignsFilterView: Ember.View.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked',

    allCampaigns: function(event) {
      Radium.App.send('allCampaigns');
      return false;
    }
  })
});
