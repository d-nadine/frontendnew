Radium.Combobox = Radium.View.extend
  classNameBindings: [
    'isInvalid'
    'disabled:is-disabled'
    ':combobox'
    ':control-box'
  ]

  click: (event) ->
    event.stopPropagation()

  sortedSource: ( ->
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      sortProperties: ['name']
      content: @get('source')
  ).property('source.[]')

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
        <button class="btn dropdown-toggle" tabindex="-1">
          <i class="icon-arrow-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each view.sortedSource}}
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

  textField: Radium.Typeahead.extend
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'
    sourceBinding: 'parentView.sortedSource'
