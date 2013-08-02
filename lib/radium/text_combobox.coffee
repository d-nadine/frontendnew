require 'lib/radium/add_active_to_parent_mixin'
require 'lib/radium/toggle_dropdown_mixin'

Radium.TextCombobox = Ember.View.extend
  classNameBindings: [
    'isInvalid'
    'isValid'
    'disabled:is-disabled'
    ':combobox'
    ':control-box'
  ]
  queryBinding: 'queryToValueTransform'

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
          <i class="ss-standard ss-navigatedown"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each item in view.source}}
            <li><a {{action "selectItem" item target=view href=true bubbles=false}}>{{item}}</a></li>
          {{/each}}
        </ul>
      </div>
    {{/unless}}
  """

  textField: Ember.TextField.extend Radium.AddActiveToParentMixin, Radium.ToggleDropdownMixin,
    valueBinding: 'parentView.query'
    placeholderBinding: 'parentView.placeholder'
    disabledBinding: 'parentView.disabled'
    didInsertElement: ->
      @$().typeahead source: @get('parentView.source')

    focusIn: (evt) ->
      @get('parentView').$().addClass('active')

  toggleDropdown: (event) ->
    @toggleProperty 'open'

  selectItem: (text) ->
    @set 'open', false
    Ember.run =>
      @set 'value', text
