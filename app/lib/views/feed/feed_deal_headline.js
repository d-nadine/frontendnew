Radium.FeedDealHeadlineView = Radium.FeedItemHeadlineView.extend({
  totalDeals: function() {
    var deals = this.getPath('parentView.deal');
    return (deals.length > 1) ? 
        deals.length + " deals" :
        deals.length + " deal";
  }.property('parentView.deal').cacheable(),
  dealsTotal: function() {
    var total = 0,
        deals = this.getPath('parentView.deal'),
        totals = deals.getEach('dealTotal');
    totals.forEach(function(item) {
      return total = total + item;
    });
    return total;
  }.property('parentView.deal').cacheable()
});