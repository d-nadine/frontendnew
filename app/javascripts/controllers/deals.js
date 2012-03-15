Radium.dealsController = Ember.ArrayProxy.create({
  selectedUser: null,
  content: [],
  filterTypes: [
    {
      title: 'Everything', 
      shortname: 'everything', 
      hasForm: false
    },
    {
      title: 'Pending', 
      shortname: 'pending', 
      hasForm: false
    },
    {
      title: 'Closed', 
      shortname: 'closed', 
      hasForm: false
    },
    {
      title: 'Paid', 
      shortname: 'paid', 
      hasForm: false
    },
    {
      title: 'Rejected', 
      shortname: 'rejected', 
      hasForm: false
    }
  ],
  /**
    @binding {content.state}
    @return {Number} Total dollar amount of pending deals
  */
  pendingTotal: function() {
    var pendingTotal = 0,
        totals = this.filterProperty('state', 'pending').getEach('dealTotal');
    totals.forEach(function(item) {
      pendingTotal += item;
    });
    return pendingTotal;
  }.property('@each.state').cacheable(),
  /**
    @binding {content.state}
    @return {Number} Total dollar amount of closed deals
  */
  closedTotal: function() {
    var closedTotal = 0,
        totals = this.filterProperty('state', 'closed').getEach('dealTotal');
    totals.forEach(function(item) {
      closedTotal += item;
    });
    return closedTotal;
  }.property('@each.state').cacheable(),
  /**
    @binding {content.state}
    @return {Number} Total dollar amount of paid deals
  */
  paidTotal: function() {
    var paidTotal = 0,
        totals = this.filterProperty('state', 'paid').getEach('dealTotal');
    totals.forEach(function(item) {
      paidTotal += item;
    });
    return paidTotal;
  }.property('@each.state').cacheable(),
  /**
    @binding {content.state}
    @return {Number} Total dollar amount of rejected deals
  */
  rejectedTotal: function() {
    var rejectedTotal = 0,
        totals = this.filterProperty('state', 'rejected').getEach('dealTotal');
    totals.forEach(function(item) {
      rejectedTotal += item;
    });
    return rejectedTotal;
  }.property('@each.state').cacheable(),
  /**
    Count the total number of unclosed deals
    @binding {content.isOverdue}
    @return {Number} Total pending and overdue deals
  */
  unclosedDeals: function() {
    return this.filter(function(item) {
      if (item.get('state') === 'pending' && item.get('isOverdue') === true) {
        return true;
      } else {
        return false;
      }
    });
  }.property('@each.isOverdue').cacheable(),

  /**
    Count the total number of unpaid deals
    @pending {content.isOverdue}
    @return {Number} Total closed and overdue deals
  */
  unpaidDeals: function() {
    return this.filter(function(item) { 
      if (item.get('state') === 'closed' && item.get('isOverdue') === true) {
        return true;
      } else {
        return false;
      }
    });
  }.property('@each.isOverdue').cacheable(),

  /**
    Count the total number of open deals
    @binding {content.unclosedDeals}
    @return {Number} Total amount of deals unclosed
  */
  unclosedCosts: function() {
    var total = 0,
        unpaid = this.get('unclosedDeals');
    
    unpaid.forEach(function(item) {
      total += item.get('dealTotal');
    });
    return total;
  }.property('@each.unclosedDeals').cacheable(),

  /**
    Count the total number of deals that are closed, but not paid
    @binding {content.unpaidDeals}
    @return {Number} Total amount of deals unpaid
  */
  unpaidCosts: function() {
    var total = 0,
        unpaid = this.get('unpaidDeals');
    
    unpaid.forEach(function(item) {
      total += item.get('dealTotal');
    });
    return total;
  }.property('@each.unpaidDeals').cacheable(),

  /**
    Count the total number of unpaid and unclosed deals
    @binding {unpaidDeals, unclosedDeals}
    @return {Number} Total overdue items
  */
  hasOverdueItems: function() {
    return (this.getPath('unpaidDeals.length') > 0 || this.getPath('unclosedDeals.length') > 0) ? true : false;
  }.property('unpaidDeals', 'unclosedDeals').cacheable(),

  /**
    Chart properties
    ================
  */

  /**
    @binding {pendingTotal, closedTotal, paidTotal, rejectedTotal}
  */
  dealStatistics: function() {
    var totalsObject = {
          pending: this.get('pendingTotal'),
          closed: this.get('closedTotal'),
          paid: this.get('paidTotal'),
          rejected: this.get('rejectedTotal')
        },
        statsArray = [];

    ['pending', 'closed', 'paid', 'rejected'].forEach(function(item) {
        var state = item.substr(0,1).toUpperCase() + 
                      item.substr(1,item.length);
        statsArray.push([state, totalsObject[item]]);
    });

    return statsArray;
  }.property('pendingTotal', 'closedTotal', 'paidTotal', 'rejectedTotal').cacheable()
});