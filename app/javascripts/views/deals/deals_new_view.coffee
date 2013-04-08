require 'lib/radium/progress_bar'

Radium.DealsNewView= Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false

  toggleChecklist: (evt) ->
    @$('.checklist-items-container').slideToggle('medium')
    @toggleProperty 'showChecklistItems'

  name: Ember.TextField.extend
    classNameBindings: ['isInvalid',':field']
    valueBinding: 'controller.name'
    didInsertElement: ->
      @$().focus()

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('controller.isSubmitted')
    ).property('value', 'controller.isSubmitted')

  contactPicker: Radium.Combobox.extend
    classNames: ['field']
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.contact'

  companyPicker: Radium.Combobox.extend
    valueBinding: 'controller.company'
    sourceBinding: 'controller.controllers.companies'
    placeholder: 'Company'
    lookupQuery: (query) ->
      @get('source').find (item) -> item.get('name') == query

  userPicker: Radium.UserPicker.extend
    classNames: ['field']
    leader: null

  description: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    rows: 3
    valueBinding: 'controller.description'
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('controller.isSubmitted')
    ).property('value', 'controller.isSubmitted')

  # FIXME: refactor after agreeing on approach
  source: Ember.View.extend
    classNameBindings: [
      'isInvalid'
      'disabled:is-disabled'
      ':combobox'
      ':control-box'
    ]
    sourceBinding: 'controller.controllers.dealSources.dealSources'
    valueBinding: 'controller.source'
    queryBinding: 'queryToValueTransform'
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
      didInsertElement: ->
        @$().typeahead source: @get('parentView.source')

    toggleDropdown: (event) ->
      @toggleProperty 'open'

    selectItem: (text) ->
      @set 'open', false
      @set 'value', text

  dealStatuses: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.status'

  referenceName: ( ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
