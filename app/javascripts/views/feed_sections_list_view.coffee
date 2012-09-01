Radium.FeedSectionsListView = Ember.CollectionView.extend
  contentWillChange: ->
    @_super.apply(this, arguments)

    @set 'controller.rendering', true

  itemViewClass: Em.View.extend
    classNames: ['feed-section']
    classNameBindings: ['content.domClass']

    didInsertElement: ->
      @_super.apply(this, arguments)

      @set 'controller.rendering', false
