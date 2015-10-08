Radium.TemplateListComponent = Ember.Component.extend
  actions:
    insertTemplate: (template) ->
      @sendAction "insertTemplate", template

      @$().parents('.btn-group').removeClass('open')

      false

  tagName: ['ul']
  classNames: ['dropdown-menu']