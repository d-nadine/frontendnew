Radium.DevelopmentMasterFeedController = Radium.Controller.extend
  activities: (->
    Radium.Activity.find()
  ).property()
