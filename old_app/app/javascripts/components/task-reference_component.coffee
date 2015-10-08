Radium.TaskReferenceComponent = Ember.Component.extend
  isDeal: Ember.computed 'reference', ->
    @get('reference').constructor is Radium.Deal

  isEmail: Ember.computed 'reference', ->
    @get('reference').constructor is Radium.Email

  isContact: Ember.computed 'reference', ->
    @get('reference').constructor is Radium.Contact

  isCompany: Ember.computed 'reference', ->
    @get('reference').constructor is Radium.Company

  isMeeting: Ember.computed 'reference', ->
    @get('reference').constructor is Radium.Meeting

  isTodo: Ember.computed 'reference', ->
    @get('reference').constructor is Radium.Todo
