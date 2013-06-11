Radium.MultipleBaseView = Radium.View.extend
  click: (evt) ->
    evt.stopPropagation()
    evt.preventDefault()

  primaryRadio: Radium.Radiobutton.extend
    leader: 'Make Primary'

    didInsertElement: ->
      @set('checked', true) if @get('controller.isPrimary')

    isChecked: Ember.computed.bool 'controller.isPrimary'

    click: (evt) ->
      evt.stopPropagation()
      @get('controller.parent').setEach('isPrimary', false)
      @set('controller.isPrimary', true)

  layout: Ember.Handlebars.compile """
    {{#each controller itemController="multipleItem"}}
      <div class="multiple-field multiple-email-address-view control-group">
        <label class="control-label">{{typeLabel}}</label>
        <div class="controls" {{bindAttr class="isInvalid"}}>
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
            {{#if showDelete}}
              <a href="#" {{action removeSelection this bubbles="false"}} >
                <i class="icon-delete"></i>
              </a>
            {{/if}}
          </div>
        {{/if}}
        {{#if showAddNew}}
          <div class="add-new">
            <a href="#" {{action addNew bubbles="false"}}><i class="icon-plus"></i></a>
          </div>
        {{/if}}
      </div>
    {{/each}}
  """
