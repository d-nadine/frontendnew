Radium.EmailsConfirmBulkEmailController = Radium.Controller.extend
  actions:
    submitCreateBulkEmail: ->
      emailsNewController = @get 'emailsNewController'

      form = @get('form')
      bulkParams = @get('bulkParams')

      emailsNewController.send 'createBulkEmail', form, bulkParams

      false

  needs: ['emailsNew', 'peopleIndex']

  emailsNewController: Ember.computed.oneWay 'controllers.emailsNew'

  checkedTotal: Ember.computed.alias 'controllers.peopleIndex.checkedTotal'
