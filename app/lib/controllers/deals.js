Radium.dealsController = Ember.ArrayProxy.create({
  content: [],
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
  statsTitle: "Your Company's Deals Statistics",
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
  }.property('pendingTotal', 'closedTotal', 'paidTotal', 'rejectedTotal').cacheable(),

  arrayDidChange: function(content, idx, removedCnt, addedCnt) {
    var self = this,
        // Grab only new array items
        newDeals = content.slice(idx);

    var createDateGroup = function(day, type, state, item) {
      var dayGroup = Ember.Object.create({
        date: day,
        datetime: item.get('date'),
        type: type,
        pending: Ember.A([]),
        closed: Ember.A([]),
        paid: Ember.A([]),
        rejected: Ember.A([])
      });
      dayGroup.get(state).pushObject(item);
      return dayGroup;
    };
    
    // Goes through only newly added array items
    newDeals.forEach(function(item) {
      var day = item.get('day'),
          week = item.get('week'),
          month = item.get('month'),
          quarter = item.get('quarter'),
          year = item.get('year'),
          state = item.get('state'),
          cache = Radium.dealsDateGroupsController.get('content');
      
      // Map and check if the date group has already been stored in memory.
      var map = cache.mapProperty('date'),
          dayIdx = map.indexOf(day),
          weekIdx = map.indexOf(week),
          monthIdx = map.indexOf(month),
          quarterIdx = map.indexOf(quarter),
          yearIdx = map.indexOf(year);
      
      // FIXME: This can probably reduced to a simpler loop
      // Day
      if (dayIdx < 0) {
        cache.pushObject(createDateGroup(day, 'day', state, item));
      } else {
        cache.objectAt(dayIdx).get(state).pushObject(item);
      }
      // Week
      if (weekIdx < 0) {
        cache.pushObject(createDateGroup(week, 'week', state, item));
      } else {
        cache.objectAt(weekIdx).get(state).pushObject(item);
      }

      // Month
      if (monthIdx < 0) {
        cache.pushObject(createDateGroup(month, 'month', state, item));
      } else {
        cache.objectAt(monthIdx).get(state).pushObject(item);
      }

      // Quarter
      if (quarterIdx < 0) {
        cache.pushObject(createDateGroup(quarter, 'quarter', state, item));
      } else {
        cache.objectAt(quarterIdx).get(state).pushObject(item);
      }

      // Year
      if (yearIdx < 0) {
        cache.pushObject(createDateGroup(year, 'year', state, item));
      } else {
        cache.objectAt(yearIdx).get(state).pushObject(item);
      }
    });

    // Made our calculations, carry on then.
    this._super(content, idx, removedCnt, addedCnt);
    
  }
});