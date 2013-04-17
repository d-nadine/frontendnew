Radium.TextCombobox = Ember.View.extend
  classNameBindings: [
    'isInvalid'
    'isValid'
    'disabled:is-disabled'
    ':combobox'
    ':control-box'
  ]
  queryBinding: 'queryToValueTransform'
  disabledBinding: 'parentView.disabled'

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      @set 'value', value
    else if !value && @get('value')
      @get 'value'
    else
      value
  ).property('value')

  template: Ember.Handlebars.compile """
    {{view view.textField}}

    {{#unless view.disabled}}
      <div {{bindAttr class="view.open:open :btn-group"}} {{action toggleDropdown target=view bubbles=false}}>
        <button class="btn dropdown-toggle" tabindex="-1">
          <i class="icon-arrow-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each item in view.source}}
            <li><a {{action selectItem item target=view href=true bubbles=false}}>{{item}}</a></li>
          {{/each}}
        </ul>
      </div>
    {{/unless}}
  """

  textField: Ember.TextField.extend
    valueBinding: 'parentView.query'
    placeholderBinding: 'parentView.placeholder'
    disabledBinding: 'parentView.disabled'
    didInsertElement: ->
      @$().typeahead source: @get('parentView.source')

  toggleDropdown: (event) ->
    @toggleProperty 'open'

  selectItem: (text) ->
    @set 'open', false
    @set 'value', text
