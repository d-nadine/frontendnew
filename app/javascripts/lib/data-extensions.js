DS.Model.reopenClass({
  getScrollData: function(resource){
    var plural = Radium.store.adapter.pluralize(resource);
    var url = '/api/%@'.fmt(plural);
    dataType = Radium.getPath(resource.capitalize());

    return{
      url: url,
      resource: plural,
      dataType: dataType
    }
  }
});
