Radium.MentionFieldView = Ember.View.extend
  classNameBindings: ['disabled:is-disabled', ':mention-field-view']

  template: Ember.Handlebars.compile """
    {{view view.textArea}}
  """
  textArea: Ember.TextArea.extend
    rows: 1
    tabIndexBinding: 'parentView.tabIndex'
    placeholderBinding: 'parentView.placeholder'
    disabledBinding: 'parentView.disabled'
    valueBinding: 'parentView.value'

    didInsertElement: ->
      @$().mentionsInput
        onDataRequest:(mode, query, callback) ->
          data = [
            { id:1, name:'Kenneth Auchenberg', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
            { id:2, name:'Jon Froda', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
            { id:3, name:'Anders Pollas', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
            { id:4, name:'Kasper Hulthin', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
            { id:5, name:'Andreas Haugstrup', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' },
            { id:6, name:'Pete Lacey', 'avatar':'http://cdn0.4dots.com/i/customavatars/avatar7112_1.gif', 'type':'contact' }
          ]

          data = _.filter(data, (item) -> item.name.toLowerCase().indexOf(query.toLowerCase()) > -1)

          callback.call(this, data)
