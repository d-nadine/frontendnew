require 'lib/radium/add_active_to_parent_mixin'
require 'lib/radium/toggle_dropdown_mixin'

Radium.AutocompleteCombobox = Radium.Combobox.extend
  queryBinding: 'queryToValueTransform'
  field: 'displayName'

  matchesSelection: (value) ->
    return unless value
    active  = @$('.typeahead .active')
    selected = active.text() if active.is(':visible')
    return unless selected
    value?.toLowerCase() == selected?.toLowerCase()

  select: ->
    typeahead = @get('childViews.firstObject').$().data('typeahead')
    typeahead.select()
    typeahead.hide()
    @$('input[type=text]').blur()

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      if  @matchesSelection(value)
        @select()
      else
        @set 'value', null
    else if !value && @get('value')
      @get "value.#{@field}"
    else
      value
  ).property('value')

  layout: Ember.Handlebars.compile """
    {{#if view.footerView}}
      {{view view.footerView tagName="span" classNames="text"}}
    {{/if}}

    {{#if view.leaderView}}
      {{view view.leaderView tagName="span" classNames="text"}}
    {{/if}}

    {{#if view.leader}}
      <span class="text">{{view.leader}}</span>
    {{/if}}

    {{view view.textField}}

    {{#unless view.disabled}}
      <div class="btn-group controlbox-dropdown-group">
        <button class="btn controlbox-dropdown" tabindex="-1" disabled="disabled">
          <i class="ss-standard ss-dropdown"></i>
        </button>
     </div>
    {{/unless}}

    {{#if view.footer}}
      <span class="text">{{view.footer}}</span>
    {{/if}}
  """

  setValue: (object) ->
    @set 'value', object.get('person')

  queryParameters: (query) ->
    term: query

  textField: Ember.TextField.extend Radium.AddActiveToParentMixin, Radium.ToggleDropdownMixin,
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'

    didInsertElement: ->
      @$().typeahead source: (query, process) =>
        queryParameters = @get('parentView').queryParameters(query)

        Radium.AutocompleteItem.find(queryParameters).then((results) =>
          process results
        , Radium.rejectionHandler)
        .then(null, Radium.rejectionHandler)

        null

      typeahead = @$().data('typeahead')

      parentView = @get('parentView')
      # make typeahead work with ember arrays
      typeahead.process = (items) ->
        items.then =>
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
