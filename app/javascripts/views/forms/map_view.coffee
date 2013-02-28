Radium.MapView = Ember.View.extend
  templateName: 'forms/map'
  classNameBindings: [
    ':control-box'
    ':datepicker-control-box'
    ':field'
    ':map'
  ]

  disabled: Ember.computed.alias('controller.isDisabled')

  locationField: Radium.FormsGroupPickerView.extend()

  showMap: (event) ->
    $("##{@get('modalId')}").parent().modal(backdrop: true)
    false

  modalId: (->
    "map-modal-#{@get('elementId')}"
  ).property()

  mapModal: Ember.View.extend
    classNames: ['modal','hide','fade']
    template: Ember.Handlebars.compile """
      <div id="{{unbound view.parentView.modalId}}" class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Modal</h3>
      </div>
      <div class="modal-body">
        <p>Do we want to use this modal?…</p>
      </div>
    """



