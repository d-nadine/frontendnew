describe("Radium#selectedCampaignController", function() {

  describe("when adding new statistics data", function() {
    it("creates a new Stat Object", function() {
      var stats = 
      {"pending_deals":{"USD":6000.0},"closed_deals":{},"paid_deals":{"USD":3000.0},"rejected_deals":{"USD":3000.0}};
      Radium.selectedCampaignController.addStatsData(stats);
      var stat = Radium.selectedCampaignController.get('campaignStats');
      expect(stat.get('pendingDeals')).toEqual(6000.0);
    });

    it("identifies different currencies", function() {
      var stats = 
      {"pending_deals":{"EUR":6000.0},"closed_deals":{},"paid_deals":{"EUR":3000.0},"rejected_deals":{"EUR":3000.0}};
      Radium.selectedCampaignController.addStatsData(stats);
      var stat = Radium.selectedCampaignController.get('campaignStats');
      expect(stat.get('pendingDeals')).toEqual(6000.0);
    });
  });

});