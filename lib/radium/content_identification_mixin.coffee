Radium.ContentIdentificationMixin = Ember.Mixin.create
  attributeBindings: ['dataModel:data-model', 'dataId:data-id']

  dataModel: (->
    if content = @get('controller.content')
      @get('controller.content').constructor.toString()
  ).property('controller.content')

  dataIdBinding: Ember.Binding.oneWay 'content.id'
