Radium.CallList = Radium.Core.extend
  isEditable: true
  description: DS.attr("string")
  user: DS.belongsTo("Radium.User", key: "user_id")
