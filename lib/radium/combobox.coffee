Radium.Combobox = Ember.View.extend
  classNameBindings: [
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
    {{#if view.leaderView}}
      {{view view.leaderView tagName="span" classNames="text"}}
    {{/if}}

    {{#if view.leader}}
      <span class="text">{{view.leader}}</span>
    {{/if}}

    {{view view.textField}}

    {{#unless view.disabled}}
      <div {{bindAttr class="view.open:open :btn-group"}} {{action toggleDropdown target=view bubbles=false}}>
        <button class="btn dropdown-toggle">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each view.source}}
            <li><a {{action selectObject this target=view href=true bubbles=false}}>{{name}}</a></li>
          {{/each}}
        </ul>
      </div>
    {{/unless}}

    {{#if view.footerView}}
      {{view view.footerView tagName="span" classNames="text"}}
    {{/if}}

    {{#if view.footer}}
      <span class="text">{{view.footer}}</span>
    {{/if}}
  """
  toggleDropdown: (event) ->
    @toggleProperty 'open'

  selectObject: (item) ->
    @set 'open', false
    @setValue item

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

  updater: (item) ->
    @set 'value', item

  textField: Ember.TextField.extend
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'

    didInsertElement: ->
      @$().typeahead source: @get('parentView.source')

      typeahead = @$().data('typeahead')

      # make typeahead work with ember arrays
      typeahead.process = (items) ->
        items = items.filter (item) => @matcher(item)

        items = @sorter(items)

        if !items.get('length')
          return if @shown then @hide() else this

        @render(items.slice(0, @options.items)).show()

      typeahead.matcher = @get('parentView.matcher')
      typeahead.sorter = @get('parentView.sorter')
      typeahead.highlighter = @get('parentView.highlighter')

      typeahead.select = ->
        val = @$menu.find('.active').data('typeahead-value')
        @updater val
        @hide()

      typeahead.updater = (item) =>
        @get('parentView').setValue item
