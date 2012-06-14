Radium.FutureFeed = Ember.ArrayProxy.extend({
  content: Ember.A(),
  init: function(){
    this._super();
  },
  arrayContentDidChange: function(startIdx, removeAmt, addAmt){
    if(addAmt === 0)
      return;

    console.log('addAmt = ' + addAmt);
  }
});
