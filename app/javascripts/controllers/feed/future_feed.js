Radium.FutureFeed = Ember.ArrayProxy.extend({
  content: Ember.A(),
  realContent: Ember.A(),
  cursor: 0,
  
  arrayContentDidChange: function(startIdx, removeAmt, addAmt){
    if(addAmt === 0)
      return;

    var realContent = this.get('realContent');

    if(this.get('content')[startIdx].get('dateHeader')){
      realContent.insertAt(0, this.get('content')[startIdx]);
      this.set('cursor', 1);
    }else if(this.get('content')[startIdx].get('activities')){
      var index = this.get('cursor');
      for(var i = 0; i < addAmt; i++){
        realContent.insertAt(index, this.get('content')[i]);
        index++;
      }
    }else{
      realContent.insertAt(1, this.get('content')[startIdx]);
      this.set('cursor', 2);
    }
  }
});
