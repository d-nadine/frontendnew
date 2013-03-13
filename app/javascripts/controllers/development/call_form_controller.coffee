require 'forms/call_form'

Radium.DevelopmentCallFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  newCall: Radium.computed.newForm('call')

  callFormDefaults: (->
    finishBy: Ember.DateTime.create()
  ).property()

  editableCall: (->
    Radium.CallForm.create
      content: Factory.createObject 'call'
        isEditable: true
  ).property()

  editableFinishedCall: (->
    Radium.CallForm.create
      content: Factory.createObject 'call'
        isFinished: true
        isEditable: true
  ).property()

  uneditableCall: (->
    Radium.CallForm.create
      content: Factory.createObject 'call'
        isEditable: false
  ).property()

  uneditableFinishedCall: (->
    Radium.CallForm.create
      content: Factory.createObject 'call'
        finished: false
        isEditable: false
  ).property()

  justAddedCall: (->
    Ember.ObjectProxy.create
      content: Radium.CallForm.create
        content: Factory.createObject 'call'
      justAdded: true
  ).property()
