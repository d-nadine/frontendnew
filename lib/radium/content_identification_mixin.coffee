Radium.ContentIdentificationMixin = Ember.Mixin.create
  attributeBindings: ['dataModel:data-model', 'dataId:data-id']

  dataModel: (->
    @get('controller.content').constructor.toString()
  ).property('controller.content')

  dataIdBinding: Ember.Binding.oneWay 'content.id'
