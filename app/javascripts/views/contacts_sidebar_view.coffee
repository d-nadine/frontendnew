Radium.ContactsSidebarView = Em.View.extend
  templateName: 'contacts/sidebar'
  campaignsFilterView: Ember.View.extend
    tagName: "ul"
    classNames: "nav nav-tabs nav-stacked"
    allCampaigns: (event) ->
      Radium.App.send "allCampaigns"
      false
