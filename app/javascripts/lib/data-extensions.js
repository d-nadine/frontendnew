DS.Model.reopenClass({
  getScrollData: function(resource){
    var plural = Radium.store.adapter.pluralize(resource);
    var url = '/api/%@'.fmt(plural);
    dataType = Radium.getPath(resource.capitalize());
    contentPath = '%@Controller.content'.fmt(plural);

    return{
      url: url,
      resource: plural,
      dataType: dataType,
      contentPath: contentPath
    }
  }
});
