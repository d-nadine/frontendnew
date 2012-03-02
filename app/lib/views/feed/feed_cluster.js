Radium.FeedClusterView = Ember.ContainerView.extend({
  childViews: ['headlineView'],
  items: [],
  loadedRecords: 0,
  totalRecords: 0,
  nestedView: null,

  headlineView: Radium.FeedItemHeadlineView.extend()


  // loadDetails: function() {
  //   var totalRecords = this.get('totalRecords'),
  //       loadedRecords = this.get('loadedRecords'),
  //       view = this.get('nestedView');

  //   if (totalRecords === loadedRecords) {
  //     this.set('isDetailsVisible', true);
  //     view.set('items', this.get('items'));
  //     view.appendTo(this.$().parent());
  //   }
  //   console.log("There are %@ loaded records out of %@".fmt(this.get('loadedRecords'), this.get('totalRecords')))
  // }.observes('loadedRecords'),

  // tester: function() {
  //   var type = this.get('filterType').toString();
  //   var ids = this.get('ids');
  //   var model = this.get('model');
  //   var view = Radium['FeedItem' + model + 'sView'].create();
  //   var loadedRecords = this.get('loadedRecords');

  //   if (this.get('isDetailsVisible')) {
  //     var test = this.get('nestedView');
  //     test.remove();
  //     this.set('isDetailsVisible', false);
  //   } else {
  //     var deets = Radium.store.findMany(Radium[model], ids);
  //     this.set('items', deets);
  //     this.set('totalRecords', deets.get('length'));
  //     this.set('nestedView', view);
  //     // Radium.Comment.reopenClass({
  //     //   url: "/%@/%@/comments".fmt()
  //     // });
  //     deets.forEach(function(item) {
  //       var deet = this;
  //       item.addObserver('isLoaded', function() {
  //         if (this.get('isLoaded')) {
  //           deet.incrementProperty('loadedRecords');
  //         }
  //       });
  //     }, this);
  //   }
  // }.observes('isDetailsVisible')
});