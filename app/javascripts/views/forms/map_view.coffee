Radium.MapView = Ember.View.extend
  templateName: 'forms/map'
  classNameBindings: [
    ':control-box'
    ':datepicker-control-box'
    ':field'
    ':map'
  ]

  leader: 'location'

  locationField: Ember.TextField.extend()

  showMap: (event) ->
    $('.modal').modal(backdrop: true)
    false

  mapModal: Ember.View.extend
    classNames: ['modal','hide','fade']
    template: Ember.Handlebars.compile """
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Modal</h3>
      </div>
      <div class="modal-body">
        <p>Do we want to use this modal?…</p>
      </div>
    """



