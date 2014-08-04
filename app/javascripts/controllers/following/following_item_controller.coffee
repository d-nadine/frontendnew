Radium.FollowingItemController = Radium.ObjectController.extend
  isCompany: Ember.computed 'model', ->
    @get('model').constructor is Radium.Company
