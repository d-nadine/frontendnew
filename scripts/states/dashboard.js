define(function(require) {
  
  return Ember.State.create({
    enter: function() {
      
    },
    test: Ember.ViewState.create({
      enter: function() {
        this.get('view').append();
      },
      view: Ember.View.create({
        template: "hi"
      })
    })
  });
});
