Radium.LeadsImportView = Radium.View.extend
  firstName: Ember.View.extend
    classNames: ['control-group']
    leader: 'First Name'
    autocomplete: Radium.Combobox.extend
      classNames: ['field']
      sourceBinding: 'controller.source'

    template: Ember.Handlebars.compile """
      <label class="control-label">{{view.leader}}</label>
      <div class="controls">
        {{view view.autocomplete}}
        <span class="help-inline preview-inline">Sami</span>
      </div>
    """
