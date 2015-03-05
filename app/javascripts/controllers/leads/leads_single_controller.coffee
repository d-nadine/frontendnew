Radium.LeadsSingleController = Radium.Controller.extend Radium.FormArrayBehaviour,
  actions:
    modelChanged: (model) ->
      @get('model').reset()
      @set 'form', null
      @set 'model', model
      ['emailAddresses', 'phoneNumbers'].forEach (relationship) =>
        @set relationship, Ember.A()
        @send 'createFormFromRelationship', model, relationship, @get(relationship)

    clearExisting: ->
      @get('model').reset()
      form = @get('contactForm')
      form.reset()

      @set 'model', form
      @set 'emailAddresses', form.get('emailAddresses')
      @set 'phoneNumbers', form.get('phoneNumbers')
      @set 'addresses', form.get('addresses')

    saveModel: ->
      @get('model').save(this)

  emailAddresses: Ember.A()
  phoneNumbers: Ember.A()
  addresses: Ember.A()
  needs: ['users']
