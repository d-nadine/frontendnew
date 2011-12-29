define(function(require) {
  
  var view = Ember.View.extend(JQ.Widget, {
    uiType: 'progressbar',
    uiOptions: ['value', 'max'],
    uiEvents: ['change', 'complete']
  });
  
  return view;
});