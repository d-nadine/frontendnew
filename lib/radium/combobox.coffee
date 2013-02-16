Radium.Combobox = Ember.View.extend
  classNameBindings: [
    'value:is-valid'
    'isInvalid'
    'disabled:is-disabled'
    ':combobox'
    ':control-box'
  ]

  queryBinding: 'queryToValueTransform'

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  lookupQuery: (query) ->
    @get('source').find (item) -> item.get('name') == query

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      @set 'value', @lookupQuery(value)
    else if !value && @get('value')
      @get 'value.name'
    else
      value
  ).property('value')

  template: Ember.Handlebars.compile """
    {{view view.textField}}

    {{#unless view.disabled}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each view.source}}
            <li><a {{action setValue this target=view href=true}}>{{name}}</a></li>
          {{/each}}
        </ul>
      </div>
    {{/unless}}
  """

  setValue: (object) ->
    @set 'value', object

  # Begin typehead customization
  matcher: (item) ->
    string = item.get 'name'
    ~string.toLowerCase().indexOf(@query.toLowerCase())
  sorter: (items) ->
    beginswith = []
    caseSensitive = []
    caseInsensitive = []

    items.forEach (item) =>
      string = item.get 'name'

      if !string.toLowerCase().indexOf(@query.toLowerCase())
        beginswith.push(item)
      else if (~string.indexOf(@query))
        caseSensitive.push(item)
      else 
        caseInsensitive.push(item)

    beginswith.concat caseSensitive, caseInsensitive

  highlighter: (item) ->
    string = item.get 'name'

    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
      "<strong>#{match}</strong>"


  textField: Ember.TextField.extend
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'

    didInsertElement: ->
      @$().typeahead source: @get('parentView.source')

      typeahead = @$().data('typeahead')

      typeahead.matcher = @get('parentView.matcher')
      typeahead.sorter = @get('parentView.sorter')
      typeahead.highlighter = @get('parentView.highlighter')

      typeahead.select = ->
        val = @$menu.find('.active').data('typeahead-value')
        @updater val
        @hide()

      typeahead.updater = (item) =>
        @set 'parentView.value', item

