Radium.FeedFilterItemView = Ember.View.extend
  tagName: 'li'
  templateName: 'filter'
  classNames: ['main-filter-item']
  classNameBindings: ['isSelected:active', 'type']
  typeBinding: 'content.type'

  setFilter: (event) ->
    type = if event.context == 'all' then null else event.context
    console.log type, @get('controller').toString()
    @get('controller').set('typeFilter', type)

  isSelected: (->
    @get('controller.typeFilter') == @get('content.type') ||
      ( !@get('controller.typeFilter') && @get('content.type') == 'all' )
  ).property('controller.typeFilter')

  addResourceButton: Ember.View.extend
    classNames: ['icon-plus']
    classNameBindings: ['class']
    tagName: 'i',
    attributeBindings: ['title'],
    class: (->
      "add-#{ @get 'parentView.content.type' }"
    ).property('parentView.content.type')
    title: (->
      if type = @get('parentView.content.type')
        type = type.humanize()
      "Add a new #{type}"
    ).property()
    click: (event) ->
      Radium.get('router.formController').show @get('parentView.content.type')
      false
