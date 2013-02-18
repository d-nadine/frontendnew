require 'lib/radium/combobox'

Radium.UserPicker = Radium.Combobox.extend
  classNameBindings: [
    ':user-picker-control-box'
  ]

  valueBinding: 'controller.user'
  sourceBinding: 'controller.users'

  lookupQuery: (query) ->
    @get('source').find (item) -> item.get('name') == query

  template: Ember.Handlebars.compile """
    <span class="text">
      Assigned To
    </span>

    {{view view.textField}}

    {{#unless view.disabled}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" {{action toggleDropdown target=view}}>
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each users}}
            <li><a {{action setValue this target=view href=true}}>{{name}}</a></li>
          {{/each}}
        </ul>
      </div>
    {{/unless}}
  """
