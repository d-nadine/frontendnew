require 'controllers/sidebar/sidebar_base_controller'

Radium.MultipleBaseController = Radium.SidebarBaseController.extend Radium.FormArrayBehaviour,
  actions:
    commit: ->
      @get("form.#{@recordArray}").forEach (item) =>
        if item.hasOwnProperty 'record'
          item.record.setProperties(name: item.get('name'), value: item.get('value'), isPrimary: item.get('isPrimary'))
        else
          if item.get('value.length') && item.get('value') != "+1"
            @get("content.#{@recordArray}").createRecord item.getProperties('name', 'value', 'isPrimary')

      model = @get("content")

      @get('content.transaction').commit()

    setForm: ->
      formArray = @get("form.#{@recordArray}")

      @send 'createFormFromRelationship', @get('model'), @recordArray, formArray
