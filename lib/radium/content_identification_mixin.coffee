Radium.ContentIdentificationMixin = Ember.Mixin.create
  attributeBindings: ['dataModel:data-model', 'dataId:data-id']

  dataModel: Ember.computed 'controller.content', ->
    if content = @get('controller.content')
      @get('controller.content').constructor.toString()

  dataIdBinding: Ember.Binding.oneWay 'content.id'
