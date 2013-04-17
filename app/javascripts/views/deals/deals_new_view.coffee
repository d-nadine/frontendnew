require 'lib/radium/progress_bar'
require 'lib/radium/radio'
require 'lib/radium/value_validation_mixin'

Radium.DealsNewView= Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false
  showDetail: false
  disabled: Ember.computed.not 'controller.hasContact'

  toggleChecklist: (evt) ->
    return if @get('disabled')

    @$('.checklist-items-container').slideToggle('medium')
    @toggleProperty 'showChecklistItems'

  toggleDetail: (evt) ->
    @$('#deal-detail').slideToggle('medium')
    @toggleProperty 'showDetail'


  name: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    didInsertElement: ->
      @$().focus()

  contactPicker: Radium.Combobox.extend Radium.ValueValidationMixin,
    sourceBinding: 'controller.contactsWithCompany'
    valueBinding: 'controller.contact'
    setValue: (object) ->
      @set 'value', object.get('contact')
    queryToValueTransform: ((key, value) ->
      if arguments.length == 2
        @set 'value', @lookupQuery(value)
      else if !value && @get('value')
        "#{@get('value.name')} (#{@get('value.company.name')})"
      else
        value
    ).property('value')

  userPicker: Radium.UserPicker.extend Radium.ValueValidationMixin,
    disabledBinding: 'parentView.disabled'
    leader: null

  description: Radium.TextArea.extend Radium.ValueValidationMixin,
    disabledBinding: 'parentView.disabled'
    rows: 3
    valueBinding: 'controller.description'

  # FIXME: refactor after agreeing on approach
  source: Ember.View.extend Radium.ValueValidationMixin,
    classNameBindings: [
      'disabled:is-disabled'
      ':combobox'
      ':control-box'
    ]
    sourceBinding: 'controller.controllers.dealSources.dealSources'
    valueBinding: 'controller.source'
    queryBinding: 'queryToValueTransform'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Source'
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

  dealStatuses: Ember.View.extend
    template: Ember.Handlebars.compile """
      <ul>
      {{#each controller.statuses}}
        {{view Radium.Radiobutton selectedValueBinding="controller.status" name="type" leaderBinding="this" valueBinding="this" tagName="li"}}
      {{/each}}
      </ul>
    """
  referenceName: ( ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
