require 'views/forms/todo_view'
require 'lib/radium/combobox'

Radium.FormsCallView = Radium.FormsTodoView.extend
  todoField: Radium.FormsTodoFieldView.extend
    placeholder: 'about...'

  contactPicker: Radium.Combobox.extend
    classNameBindings: ['isValid', 'isInvalid', ':field']
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.contact'
    placeholder: 'Choose a contact to call...'
    disabledBinding: 'controller.isContactPickerDisabled'
    expandedBinding: 'controller.isExpanded'
    isValid: (->
      @get('controller.contact')
    ).property('controller.controller')
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      not @get('controller.contact')
    ).property('controller.isSubmitted', 'controller.contact')

  callBox: Radium.View.extend
    contactBinding: 'controller.reference'
    classNames: ['btn-group', 'call-control-box']
    dropDownTabIndex: (->
      return unless @get('tabIndex')
      @get('tabIndex') + 1
    ).property('tabIndex')

    toggleDropdown: (event) ->
      @$().toggleClass 'open'

    template: Ember.Handlebars.compile """
      <button class="btn btn-success" {{bindAttr tabIndex="view.tabIndex"}} {{action startCall bubbles=false}}>
        <i class="icon-call"></i>
      </button>
      <button class="btn btn-success dropdown-toggle" {{action toggleDropdown target=view bubbles=false}} {{bindAttr tabindex="view.dropDownTabIndex"}}>
        <span class="caret"></span>
      </button>
      <ul class="dropdown-menu">
        {{#each view.contact.phoneNumbers}}
          <li><a href="#">{{name}}: {{number}}</a></li>
        {{/each}}
      </ul>
    """
