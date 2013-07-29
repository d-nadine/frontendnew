require 'views/forms/todo_view'
require 'lib/radium/combobox'
require 'lib/radium/contact_picker'

Radium.FormsCallView = Radium.FormsTodoView.extend
  todoField: Radium.FormsTodoFieldView.extend
    placeholder: 'about...'

  contactPicker: Radium.ContactPicker.extend
    classNameBindings: ['isValid', 'isInvalid', ':field']
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.contact'
    placeholder: 'Choose a contact to call...'
    disabledBinding: 'controller.isContactPickerDisabled'
    expandedBinding: 'controller.isExpanded'
    isValid: (->
      not @get('isInvalid')
    ).property('controller.controller', 'isInvalid')
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      return false if @get('controller.contact')

      if @get('controller.isBulk') && @get('controller.reference.length') && @get('controller.reference').some((item) -> item.constructor is Radium.Contact)
        return false
    ).property('controller.isSubmitted', 'controller.contact', 'controller.description')

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
