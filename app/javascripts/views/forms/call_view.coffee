require 'views/forms/todo_view'
require 'lib/radium/combobox'

Radium.FormsCallView = Radium.FormsTodoView.extend
  todoField: Radium.FormsTodoFieldView.extend
    placeholder: 'about...'

  contactPicker: Radium.Combobox.extend
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.reference'
    placeholder: 'Choose a contact to call...'
    disabledBinding: 'controller.isContactPickerDisabled'

  callBox: Ember.View.extend
    contactBinding: 'controller.reference'
    classNames: ['btn-group', 'call-control-box']
    dropDownTabIndex: (->
      return unless @get('tabIndex')
      @get('tabIndex') + 1
    ).property('tabIndex')

    click: (event) ->
      event.preventDefault()
      event.stopPropagation()

    toggleDropdown: (event) ->
      @$().toggleClass 'open'

    template: Ember.Handlebars.compile """
      <button class="btn btn-success" {{bindAttr tabIndex="view.tabIndex"}} {{action startCall}}>
        <i class="icons-call-white"></i>
      </button>
      <button class="btn btn-success dropdown-toggle data-toggle="dropdown" {{action toggleDropdown target=view}} {{bindAttr tabindex="view.dropDownTabIndex"}}>
        <span class="caret"></span>
      </button>
      <ul class="dropdown-menu">
        {{#each view.contact.phoneNumbers}}
          <li><a href="#">{{name}}: {{number}}</a></li>
        {{/each}}
      </ul>
    """

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
