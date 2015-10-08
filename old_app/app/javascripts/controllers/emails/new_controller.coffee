Radium.EmailsNewController = Radium.Controller.extend Ember.Evented,
  Radium.SaveEmailMixin,
  Radium.SaveTemplateMixin,

  actions:
    submitCreateBulkEmail: ->
      @send 'createBulkEmail', @get('form'), @get('bulkParams')

      false

    confirmBulkEmail: (form, bulkParams) ->
      @setProperties
        form: form
        bulkParams: bulkParams

      @set "showDeleteConfirmation", true

      false

    changeViewMode: (mode) ->
      @transitionToRoute "emails.new", queryParams: mode: mode, from_people: false

      false

  queryParams: ['mode', 'from_people']

  mode: 'single'
  from_people: false
  form: null
  bulkParams: null

  isBulkEmail: Ember.computed.equal 'mode', "bulk"

  showDeleteConfirmation: false

  needs: ['emailsNew', 'peopleIndex']

  emailsNewController: Ember.computed.oneWay 'controllers.emailsNew'

  checkedTotal: Ember.computed.alias 'controllers.peopleIndex.checkedTotal'
