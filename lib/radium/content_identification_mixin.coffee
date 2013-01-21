Radium.ContentIdentificationMixin = Ember.Mixin.create
 attributeBindings: ['dataType:data-type', 'dataId:data-id']
 dataType: (->
   @get('content').constructor.toString()
 ).property('content')
 dataIdBinding: Ember.Binding.oneWay 'content.id'
