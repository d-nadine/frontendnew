require 'lib/radium/add_active_to_parent_mixin'
require 'lib/radium/toggle_dropdown_mixin'

Radium.Combobox = Radium.View.extend
  actions:
    toggleDropdown: (event) ->
      @toggleProperty 'open'

    selectObject: (item) ->
      @set 'open', false
      @setValue item

  classNameBindings: [
    'isInvalid'
    'disabled:is-disabled'
    ':combobox'
    ':control-box'
  ]

  field: 'name'

  click: (event) ->
    event.stopPropagation()

  sortedSource: ( ->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortProperties: [@field]
      content: @get('source')
  ).property('source.[]')

  queryBinding: 'queryToValueTransform'

  isSubmitted: Ember.computed.alias('controller.isSubmitted')

  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  lookupQuery: (query) ->
    @get('source').find (item) => item.get(@field) == query

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      @set 'value', @lookupQuery(value)
    else if !value && @get('value')
      @get "value.#{@field}"
    else
      value
  ).property('value')

  layout: Ember.Handlebars.compile """
    {{#if view.leaderView}}
      {{view view.leaderView tagName="span" classNames="text"}}
    {{/if}}

    {{#if view.leader}}
      <span class="text">{{view.leader}}</span>
    {{/if}}

    {{view view.textField}}

    {{#unless view.disabled}}
      <div {{bind-attr class="view.open:open :btn-group :controlbox-dropdown-group"}} {{action toggleDropdown target=view bubbles=false}}>
        <button class="btn controlbox-dropdown dropdown-toggle" tabindex="-1" type="button">
          <i class="ss-standard ss-dropdown"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each view.sortedSource}}
            <li>
              {{yield}}
            </li>
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

  template: Ember.Handlebars.compile """
    <a {{action selectObject this target=view href=true bubbles=false}}>{{name}}</a>
  """

  setValue: (object) ->
    @set 'value', object

  # Begin typehead customization
  matcher: (item) ->
    string = item.get @field
    return unless @query
    ~string.toLowerCase().indexOf(@query.toLowerCase())

  sorter: (items) ->
    beginswith = []
    caseSensitive = []
    caseInsensitive = []

    items.forEach (item) =>
      string = item.get @field

      if !string.toLowerCase().indexOf(@query.toLowerCase())
        beginswith.push(item)
      else if (~string.indexOf(@query))
        caseSensitive.push(item)
      else
        caseInsensitive.push(item)

    beginswith.concat caseSensitive, caseInsensitive

  highlighter: (item) ->
    string = item.get @field

    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
      "<strong>#{match}</strong>"

  updater: (item) ->
    @set 'value', item

  textField: Ember.TextField.extend Radium.AddActiveToParentMixin, Radium.ToggleDropdownMixin,
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'

    didInsertElement: ->
      @$().typeahead source: @get('parentView.sortedSource')

      typeahead = @$().data('typeahead')

      parentView = @get('parentView')
      # make typeahead work with ember arrays
      typeahead.process = (items) ->
        parentView.set 'open', false
        items = items.filter (item) => @matcher(item)

        items = @sorter(items)

        if !items.get('length')
          return if @shown then @hide() else this

        @render(items.slice(0, @options.items)).show()

      typeahead.matcher = @get('parentView.matcher').bind(@get('parentView'))
      typeahead.sorter = @get('parentView.sorter').bind(@get('parentView'))
      typeahead.highlighter = @get('parentView.highlighter').bind(@get('parentView'))

      typeahead.select = ->
        val = @$menu.find('.active').data('typeahead-value')
        @updater val
        @hide()

      typeahead.updater = (item) =>
        @get('parentView').setValue item
