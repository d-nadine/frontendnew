Radium.dealsController = Radium.feedController.create({
  content: [],
  dateFilter: null,
  // Filter the feed by type
  categoryFilter: 'everything',
  filterTypes: [
    Ember.Object.create({
      title: 'Everything', 
      shortname: 'everything', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Pending', 
      shortname: 'pending', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Closed', 
      shortname: 'closed', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Paid', 
      shortname: 'paid', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Rejected', 
      shortname: 'rejected', 
      isMain: true
    })
  ],
  statsTitle: "Statistics",
  allStats: [
        ['Apple', 18385],
        ['Nokia', 12283],
        ['Microsoft', 8238],
        ['Google', 6873],
        ['Yahoo', 6612]

      ],
  // arrayDidChange: function(content, idx, removedCnt, addedCnt) {
    // var self = this,
    //     // Grab only new array items
    //     newDeals = content.slice(idx);

    // var createDateGroup = function(day, type, state, item) {
    //   var dayGroup = Ember.Object.create({
    //     date: day,
    //     datetime: item.get('date'),
    //     type: type,
    //     pending: Ember.A([]),
    //     closed: Ember.A([]),
    //     paid: Ember.A([]),
    //     rejected: Ember.A([])
    //   });
    //   dayGroup.get(state).pushObject(item);
    //   return dayGroup;
    // };
        
    // // Goes through only newly added array items
    // newDeals.forEach(function(item) {
    //   var day = item.get('day'),
    //       week = item.get('week'),
    //       month = item.get('month'),
    //       quarter = item.get('quarter'),
    //       year = item.get('year'),
    //       state = item.get('state'),
    //       // Cache `Radium.activityDateGroupsController`
    //       cache = Radium.activityDateGroupsController.get('content');
      
    //   // Map and check if the date group has already been stored in memory.
    //   var map = cache.mapProperty('date');
    //       dayIdx = map.indexOf(day),
    //       weekIdx = map.indexOf(week),
    //       monthIdx = map.indexOf(month),
    //       quarterIdx = map.indexOf(quarter),
    //       yearIdx = map.indexOf(year);
      
    //   // FIXME: This can probably reduced to a simpler loop
    //   // Day
    //   if (dayIdx < 0) {
    //     cache.pushObject(createDateGroup(day, 'day', state, item));
    //   } else {
    //     cache.objectAt(dayIdx).get(state).pushObject(item);
    //   }
    //   // Week
    //   if (weekIdx < 0) {
    //     cache.pushObject(createDateGroup(week, 'week', state, item));
    //   } else {
    //     cache.objectAt(weekIdx).get(state).pushObject(item);
    //   }

    //   // Month
    //   if (monthIdx < 0) {
    //     cache.pushObject(createDateGroup(month, 'month', state, item));
    //   } else {
    //     cache.objectAt(monthIdx).get(state).pushObject(item);
    //   }

    //   // Quarter
    //   if (quarterIdx < 0) {
    //     cache.pushObject(createDateGroup(quarter, 'quarter', state, item));
    //   } else {
    //     cache.objectAt(quarterIdx).get(state).pushObject(item);
    //   }

    //   // Year
    //   if (yearIdx < 0) {
    //     cache.pushObject(createDateGroup(year, 'year', state, item));
    //   } else {
    //     cache.objectAt(yearIdx).get(state).pushObject(item);
    //   }
    // });

    // Made our calculations, carry on then.
  //   this._super(content, idx, removedCnt, addedCnt);

  // }
});