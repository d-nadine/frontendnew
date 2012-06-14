Radium.FutureFeed = Ember.ArrayProxy.extend({
  content: Ember.A(),
  realContent: Ember.A(),
  
  arrayContentDidChange: function(startIdx, removeAmt, addAmt){
    if(addAmt === 0)
      return;

    if(this.get('content')[startIdx].get('dateHeader')){

    }
  }
});
