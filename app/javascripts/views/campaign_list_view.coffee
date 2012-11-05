Radium.CampaignListView = Ember.View.extend
  tagName: "li"
  classNameBindings: ["isSelected:active"]

  #  isSelected: (->
  #    campaign = @get("item")
  #    selectedCampaign = @getPath("parentView.parentView.selectedCampaign")
  #    true  if campaign is selectedCampaign
  #  ).property("parentView.parentView.selectedCampaign").cacheable()
  #
  #  filterCampaigns: (event) ->
  #    campaign = @get("item")
  #    Radium.App.send "selectCampaign", campaign
  #    false
