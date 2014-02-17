Radium.MultipleBaseView = Radium.View.extend
  click: (evt) ->
    evt.stopPropagation()
    evt.preventDefault()

  primaryRadio: Radium.Radiobutton.extend
    classNames: 'primary-label'
    leader: 'Primary'

    didInsertElement: ->
      @set('checked', true) if @get('controller.isPrimary')

    isChecked: Ember.computed.bool 'controller.isPrimary'

    click: (evt) ->
      evt.stopPropagation()
      @get('controller').send 'setIsPrimary'

  layout: Ember.Handlebars.compile """
    {{#each controller itemController="multipleItem"}}
      <div {{bind-attr class=":multiple-field :multiple-email-address-view :control-group isPrimary"}}>
        <label class="control-label">{{typeLabel}}</label>
        <div class="controls" {{bind-attr class="isInvalid"}}>
          {{#if showDelete}}
            <div class="pull-right">
              <a href="#" {{action "removeSelection" this bubbles="false"}} class="btn btn-link btn-remove-field">
                <i class="ss-symbolicons-block ss-trash"></i>
              </a>
            </div>
          {{/if}}

          {{yield}}

          {{#if showDropDown}}
            <div class="selector">
              <div class="btn-group mutiple-field" {{bind-attr class="open:open"}}>
                <button class="btn" {{action "toggleOpen" bubbles="false"}}>
                  {{name}}
                </button>
                <a class="btn dropdown-toggle needsclick" data-toggle="dropdown" href="#" {{action "toggleOpen"}}>
                  <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                  {{#each labels}}
                    <li><a href="#" {{action "selectValue" this}}>{{this}}</a></li>
                  {{/each}}
                </ul>
              </div>
              {{view view.primaryRadio}}
            </div>
          {{/if}}
          <div class="add-new">
            {{#if showAddNew}}
              <a href="#" {{action "addNew" bubbles="false"}} class="btn btn-link btn-remove-field">
                <i class="ss-standard ss-plus"></i> Add New
              </a>
            {{/if}}
            {{#if showAddNewAddress}}
              <a href="#" {{action "addNew" bubbles="false"}} class="btn btn-link btn-remove-field">
                <i class="ss-standard ss-plus"></i> Add New
              </a>
            {{/if}}
          </div>
        </div>
      </div>
    {{/each}}
  """
