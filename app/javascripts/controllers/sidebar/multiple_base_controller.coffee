require 'controllers/sidebar/sidebar_base_controller'

Radium.MultipleBaseController = Radium.SidebarBaseController.extend Radium.FormArrayBehaviour,
  actions:
    commit: ->
      @setModelFromHash(@get('model'), @recordArray, @get("form.#{@recordArray}"))

      model = @get("content")

      model.save()

    setForm: ->
      formArray = @get("form.#{@recordArray}")

      @createFormFromRelationship @get('model'), @recordArray, formArray
