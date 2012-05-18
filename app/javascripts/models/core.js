/**
  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`
  
*/

Radium.Core = DS.Model.extend({
  createdAt: DS.attr('dateTime', {
    key: 'created_at'
  }),
  updatedAt: DS.attr('dateTime', {
    key: 'updated_at'
  }),
  updated_at: DS.attr('dateTime'),
  created_at: DS.attr('dateTime'),

  // @returns {Ember.DateTime}
  // rawDate: function() {
  //   return new Date(this.get('updatedAt')).getTime();
  // }.property('updatedAt').cacheable(),
  // date: function() {
  //   var date = new Date(this.get('updatedAt')).getTime();
  //   return Ember.DateTime.create(date);
  // }.property('updatedAt').cacheable(),

  // day: function() {
  //   return this.get('date').toFormattedString('%Y-%m-%d');
  // }.property('date').cacheable(),

  // week: function() {
  //   return this.get('date').toFormattedString('%Y-%W');
  // }.property('date').cacheable(),

  // month: function() {
  //   return this.get('date').toFormattedString('%Y-%m');
  // }.property('date').cacheable(),

  // // Bind to the `timestamp` property instead of `time` property so we can 
  // // calculate what quarter we're in.
  // quarter: function() {
  //   var quarter,
  //       date = this.get('updatedAt'),
  //       month = new Date(date).getMonth() + 1;
  //     if (month <= 3) { quarter = 1; }
  //     if (month > 3 && month <= 6) { quarter = 2; }
  //     if (month > 6 && month <= 9) { quarter = 3; }
  //     if (month > 9 && month <= 12) { quarter = 4; }
  //   return this.get('date').toFormattedString('%Y-Q') + quarter;
  // }.property('updatedAt').cacheable(),
  
  // year: function() {
  //   return this.get('date').toFormattedString('%Y');
  // }.property('date').cacheable()
});