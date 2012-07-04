Radium.FutureFeed = Ember.ArrayProxy.extend({
  content: Ember.A(),
  realContent: Ember.A(),
  cursor: 0,
  
  arrayContentDidChange: function(startIdx, removeAmt, addAmt){
    if(addAmt === 0)
      return;

    var realContent = this.get('realContent'),
        newItem = this.get('content')[startIdx];

    //TODO: find out why the observer is firing twice for dateHeader items
    if(this.realContent.contains(newItem)){
      return;
    }

    if(newItem.get('dateHeader')){
      realContent.insertAt(0, newItem);
      this.set('cursor', 1);
    }else if(newItem.get('activities')){
      var index = this.get('cursor');
      for(var i = 0; i < addAmt; i++){
        realContent.insertAt(index, this.get('content')[i]);
        index++;
      }
    }else{
      realContent.insertAt(1, newItem);
      this.set('cursor', 2);
    }
  }
});
