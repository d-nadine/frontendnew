Radium.MapView = Ember.View.extend
  templateName: 'forms/map'
  classNameBindings: [
    ':control-box'
    ':datepicker-control-box'
    ':field'
    ':map'
  ]

  leader: 'location'
  disabled: Ember.computed.alias('controller.isDisabled')

  locationField: Radium.MentionFieldView.extend
    classNameBindings: [':location']
    disabledBinding: 'parentView.disabled'
    valueBinding: 'parentView.text'
    search: (mode, query, callback) ->
      data = [
        { id:1, name:'Apple', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
        { id:2, name:'Another Company', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
        { id:3, name:'Bosh', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
        { id:4, name:'Crystal', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
      ]

      data = _.filter(data, (item) -> item.name.toLowerCase().indexOf(query.toLowerCase()) > -1)

      callback.call(this, data)


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



