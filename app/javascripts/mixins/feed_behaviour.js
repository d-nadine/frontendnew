Radium.FeedBehaviour = Ember.Mixin.create({
  didInsertElement: function(){
    $('html,body').scrollTop(5);
  }
});
