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
      @get('controller').setIsPrimary()

  layout: Ember.Handlebars.compile """
    {{#each controller itemController="multipleItem"}}
      <div {{bindAttr class=":multiple-field :multiple-email-address-view :control-group isPrimary"}}>
        <label class="control-label">{{typeLabel}}</label>
        <div class="controls" {{bindAttr class="isInvalid"}}>
          {{#if showDelete}}
            <div class="pull-right">
              <a href="#" {{action removeSelection this bubbles="false"}} class="btn btn-link">
                <i class="ss-symbolicons-block ss-trash"></i>
              </a>
            </div>
          {{/if}}
          {{yield}}
        </div>
        {{#if showDropDown}}
          <div class="controls selector">
            <div class="btn-group mutiple-field" {{bindAttr class="open:open"}}>
              <button class="btn" {{action toggleOpen bubbles="false"}}>
                {{name}}
              </button>
              <a class="btn dropdown-toggle" data-toggle="dropdown" href="#" {{action toggleOpen}}>
                <span class="caret"></span>
              </a>
              <ul class="dropdown-menu">
                {{#each labels}}
                  <li><a href="#" {{action selectValue this}}>{{this}}</a></li>
                {{/each}}
              </ul>
            </div>
            {{view view.primaryRadio}}
          </div>
        {{/if}}
        <div class="clearfix add-new">
          {{#if showAddNew}}
            <a href="#" {{action addNew bubbles="false"}} class="btn btn-link btn-block">
              <i class="ss-standard ss-plus"></i> Add New
            </a>
          {{/if}}
          {{#if showAddNewAddress}}
            <a href="#" {{action addNew bubbles="false"}} class="btn btn-link btn-block">
              <i class="ss-standard ss-plus"></i> Add New
            </a>
          {{/if}}
        </div>
      </div>
    {{/each}}
  """
