Radium.EmailsNewController = Radium.Controller.extend Ember.Evented,
  Radium.SaveEmailMixin,
  Radium.SaveTemplateMixin,

  actions:
    changeViewMode: (mode) ->
      @transitionToRoute "emails.new", queryParams: mode: mode, from_people: false

      false

  queryParams: ['mode', 'from_people']

  mode: 'single'
  from_people: false

  isBulkEmail: Ember.computed.equal 'mode', "bulk"
